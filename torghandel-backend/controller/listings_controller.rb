require_relative 'application_controller'
require_relative '../models/listings'


##
# Controller for handling listing-related HTTP requests.
#
# Routes are prefixed with `/api/listings` and include CRUD functionality.
#
class ListingsController < ApplicationController
  # @method GET
  #
  # @route GET /api/listings
  #
  # Fetches all listings in the database.
  #
  # @return [JSON] A JSON array of all listings.
  #
  get '/api/listings' do
    content_type :json
    { content: Listing.all }.to_json
  end

  # @method GET
  #
  # GET /api/listings/:id
  #
  # Fetches a single listing by ID.
  #
  # @param [Integer] id The ID of the listing to retrieve.
  # @return [JSON] A JSON object representing the listing, or 404 if not found.
  #
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

  # @method POST
  # POST /api/listings
  #
  # Creates a new listing. Accepts parameters for name, description, cost, tags, and optional image.
  #
  # @param [String] name The name of the listing.
  # @param [String] description The listing's description.
  # @param [Numeric] cost The cost of the item.
  # @param [Tempfile] image The uploaded image file (optional).
  # @param [String] tags A comma-separated string of tag names.
  # @return [JSON] A confirmation message with image URL.
  post '/api/listings' do

    name = params[:name]
    description = params[:description]
    cost = params[:cost]
    image_filename = params[:image] ? params[:image][:filename] : ""
    owner_id = session[:user_id]
    tag_string = params["tags"] || "" #example skräp, bil
    tags = tag_string.split(',').map(&:strip).reject(&:empty?)

    p owner_id
    p "session[:user_id] is #{session[:user_id]}"

    if params[:image] && params[:image][:tempfile]
        FileUtils.mkdir_p("public/img")
        path = File.join("public/img", image_filename)
        File.open(path, "wb") { |file| file.write(params[:image][:tempfile].read) }
    end

    listing_id = Listing.create(name, description, cost, image_filename, owner_id, tags)


    content_type :json
    { message: "Listing created", image_url: "http://localhost:9292/img/#{image_filename}" }.to_json
  end

  # @method POST
  #
  # POST /api/listings/:id/delete
  #
  # Deletes a listing by ID.
  #
  # @param [Integer] id The ID of the listing to delete.
  # @return [JSON] A confirmation message.
  #
  post '/api/listings/:id/delete' do
    params.inspect
    Listing.delete(params[:id].to_i)
    @listings = Listing.all

    content_type :json
    { message: "Listing deleted by admin" }.to_json
  end

  # @method POST
  #
  # POST /api/listings/:id/update
  #
  # Updates a listing by ID. Accepts updated name, description, cost, and optionally an image.
  #
  # @param [Integer] id The ID of the listing to update.
  # @param [String] name The updated name.
  # @param [String] description The updated description.
  # @param [Numeric] cost The updated cost.
  # @param [Tempfile] image The new image file (optional).
  # @return [JSON] A confirmation message.
  #
  post '/api/listings/:id/update' do

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
