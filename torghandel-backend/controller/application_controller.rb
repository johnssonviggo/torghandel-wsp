require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'

require_relative '../models/database'

class ApplicationController < Sinatra::Base
  use Rack::Session::Cookie, key: "rack.session",
                               path: "/",
                               secret: ENV["SESSION_SECRET"]

  configure do
    enable :cross_origin
    set :allow_origin, "*"
    set :allow_methods, "GET, POST, OPTIONS"
    set :allow_headers, "Content-Type, Authorization"
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:5173'
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    Database.connection.execute("PRAGMA foreign_keys = ON")
  end

  set :allow_origin, "*"
  set :allow_methods, "GET, POST, OPTIONS"
  set :allow_headers, "Content-Type, Authorization"

  options "*" do
      response.headers["Access-Control-Allow-Origin"] = "http://localhost:5173"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
      halt 200
  end

  Database.connection
end
