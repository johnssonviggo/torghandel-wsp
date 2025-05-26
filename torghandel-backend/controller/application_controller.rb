require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'

require_relative '../models/database'

##
# Base application controller that sets up session management,
# CORS (Cross-Origin Resource Sharing), and shared configuration for all routes.
#
# This controller is inherited by all other route controllers in the application.
class ApplicationController < Sinatra::Base

  # Enable cookie-based sessions.
  #
  # @example Session configuration
  #   key: "rack.session"
  #   path: "/"
  #   secret: ENV["SESSION_SECRET"]
  use Rack::Session::Cookie, key: "rack.session",
                               path: "/",
                               secret: ENV["SESSION_SECRET"]

                               
  # Configuration block that enables CORS and defines allowed origins, methods, and headers.
  configure do
    enable :cross_origin
    set :allow_origin, "http://localhost:*"
    set :allow_methods, "GET, POST, OPTIONS"
    set :allow_headers, "Content-Type, Authorization"
  end

  # Before each request, set CORS response headers and enable foreign key support in SQLite.
  #
  # @note This is run before every request handled by the application.
  before do
    origin = request.env["HTTP_ORIGIN"]
    if origin && origin.match?(/^http:\/\/localhost(:\d+)?$/)  # Allow all localhost subdomains and ports
      response.headers['Access-Control-Allow-Origin'] = origin
    else
      response.headers['Access-Control-Allow-Origin'] = 'http://localhost:4173'  # Fallback to a default port if needed
    end

    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    Database.connection.execute("PRAGMA foreign_keys = ON")
  end

  # Redundant CORS settings for compatibility.
  set :allow_origin, "*"
  set :allow_methods, "GET, POST, OPTIONS"
  set :allow_headers, "Content-Type, Authorization"

  # Handles preflight OPTIONS requests for CORS.
  #
  # @route OPTIONS /*
  # @return [200 OK] Always returns a success for preflight checks
  options "*" do
    origin = request.env["HTTP_ORIGIN"]
    if origin && origin.match?(/^http:\/\/localhost(:\d+)?$/)  # Check if the origin is from localhost with any port
      response.headers["Access-Control-Allow-Origin"] = origin
    else
      response.headers["Access-Control-Allow-Origin"] = 'http://localhost:4173'  # Fallback for preflight
    end
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    halt 200
  end

  # Initializes the database connection on load.
  #
  # @return [SQLite3::Database] The active database connection
  Database.connection
end
