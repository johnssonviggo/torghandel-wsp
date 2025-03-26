require 'bundler'
Bundler.require
require_relative 'app'
# require_relative 'controller/listings_controller'
# require_relative 'controller/users_controller'

run App
# run Rack::URLMap.new(
#   "/" => App,
#   "/users" => UsersController
# )
