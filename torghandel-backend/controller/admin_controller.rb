require_relative 'application_controller'
require_relative '../models/admin'
require 'json'
require 'bcrypt'

class AdminController < ApplicationController
  post '/api/admin/login' do
    data = JSON.parse(request.body.read)

    p "Received data: #{data}"

    admin = Admin.find_by_username(data["admin_name"])


    if admin
      p "Admin found: #{admin}" # Debugging output in your terminal
      p "detta är bra"
    else
      p "Admin not found with name: #{data['admin_name']}"
      p "inte bra"
    end

    if admin && BCrypt::Password.new(admin["admin_password"]) == data["admin_password"]
      session[:admin_id] = admin["id"]
      puts "Admin ID set in session: #{session[:admin_id]}" # Debugging output
      content_type :json
      { message: "Admin login successful", admin: { id: admin["id"], admin_name: admin["admin_name"] } }.to_json
    else
      halt 401, { message: "Invalid admin credentials" }.to_json
    end
  end

  post '/api/admin/logout' do
    session.clear
    content_type :json
    { message: "Admin logged out" }.to_json
  end

  get '/api/admins' do
    admins = Admin.all
    content_type :json
    { admins: admins }.to_json
  end
end
