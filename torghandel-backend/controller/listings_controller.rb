require_relative 'application_controller'
require_relative '../models/listings'

class ListingsController < ApplicationController
  # get '/img/:filename' do
  #   send_file File.join(settings.public_folder, 'img', params[:filename])
  # end

  get '/api/listings' do
    content_type :json
    { content: Listing.all }.to_json
  end

  get '/api/listings/:id' do
    listing = Listing.find(params[:id])

    if listing
        listing["image_url"] = listing["image"] ? "http://localhost:9292/img/#{listing['image']}" : "https://via.placeholder.com/150"
        content_type :json
        listing.to_json
    else
        halt 404, { message: "Listing not found" }.to_json
    end
  end

  post '/api/listings' do
    name = params[:name]
    description = params[:description]
    cost = params[:cost]
    image_filename = params[:image] ? params[:image][:filename] : ""

    if params[:image] && params[:image][:tempfile]
        FileUtils.mkdir_p("public/img")
        path = File.join("public/img", image_filename)
        File.open(path, "wb") { |file| file.write(params[:image][:tempfile].read) }
    end

    Listing.create(name, description, cost, image_filename)
    content_type :json
    { message: "Listing created", image_url: "http://localhost:9292/img/#{image_filename}" }.to_json
  end

  post '/api/listings/:id/delete' do
    halt 401, { message: "Unauthorized" }.to_json unless session[:admin_id]  # Only admins can delete

    listing = Listing.find(params[:id])
    halt 404, { message: "Listing not found" }.to_json unless listing

    # Listing.delete(params[:id])
    # content_type :json
    # { message: "Listing deleted" }.to_json

    Listing.delete(params[:id])
    content_type :json
    { message: "Listing deleted by admin" }.to_json
  end

  post '/api/listings/:id/update' do
    halt 401, { message: "Unauthorized" }.to_json unless session[:admin_id]
    
    name = params[:name]
    description = params[:description]
    cost = params[:cost]
    image_filename = params[:image] ? params[:image][:filename] : nil

    if image_filename && params[:image][:tempfile]
        FileUtils.mkdir_p("public/img")
        path = File.join("public/img", image_filename)
        File.open(path, "wb") { |file| file.write(params[:image][:tempfile].read) }
    end

    Listing.update(params[:id], name, description, cost, image_filename)
    content_type :json
    { message: "Listing updated successfully" }.to_json
  end
end
