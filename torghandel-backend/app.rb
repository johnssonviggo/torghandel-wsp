require 'json'
require 'sinatra'
require 'sinatra/cross_origin'
require 'bcrypt'

require_relative './models/listings'

require_relative 'controller/application_controller'
require_relative 'controller/users_controller'
require_relative 'controller/listings_controller'



class App < ApplicationController
    set :public_folder, 'public'

    use UsersController
    use ApplicationController
    use ListingsController
end
