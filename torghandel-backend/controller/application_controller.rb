require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'

class ApplicationController < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
end
