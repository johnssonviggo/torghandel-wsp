require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'

require_relative '../models/database'

class ApplicationController < Sinatra::Base
  configure do
    enable :cross_origin
    set :allow_origin, "*"
    set :allow_methods, "GET, POST, OPTIONS"
    set :allow_headers, "Content-Type, Authorization"
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
  end

  set :allow_origin, "*"
  set :allow_methods, "GET, POST, OPTIONS"
  set :allow_headers, "Content-Type, Authorization"

  options "*" do
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
      halt 200
  end

  Database.connection
end
