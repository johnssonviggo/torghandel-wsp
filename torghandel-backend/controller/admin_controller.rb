require_relative 'application_controller'
require_relative '../models/admin'
require 'json'
require 'bcrypt'

##
# Controller handling admin authentication and data retrieval.
class AdminController < ApplicationController

  # @method POST
  #
  # Logs in an admin by checking credentials.
  #
  # @route POST /api/admin/login
  # @param [JSON] request body containing:
  #   - admin_name [String] the admin's username
  #   - admin_password [String] the admin's password
  # @return [JSON] success message with admin info if credentials match
  # @raise [401] if credentials are invalid
  post '/api/admin/login' do
    data = JSON.parse(request.body.read)

    p "Received data: #{data}"

    admin = Admin.find_by("admin_name", data["admin_name"])

    if admin
      p "Admin found: #{admin}"
      p "detta är bra"
    else
      p "Admin not found with name: #{data['admin_name']}"
      p "inte bra"
    end

    if admin && BCrypt::Password.new(admin["admin_password"]) == data["admin_password"]
      session[:admin_id] = admin["id"]
      puts "Admin ID set in session: #{session[:admin_id]}"
      content_type :json
      { message: "Admin login successful", admin: { id: admin["id"], username: admin["admin_name"] } }.to_json
    else
      halt 401, { message: "Invalid admin credentials" }.to_json
    end
  end

  # @method POST
  #
  # Logs out the current admin by clearing the session.
  #
  # @route POST /api/admin/logout
  # @return [JSON] logout confirmation message
  post '/api/admin/logout' do
    session.clear
    content_type :json
    { message: "Admin logged out" }.to_json
  end

  # @method GET
  #
  # Retrieves all admins from the database.
  #
  # @route GET /api/admins
  # @return [JSON] list of all admin users
  get '/api/admins' do
    admins = Admin.all
    content_type :json
    { admins: admins }.to_json
  end
end
