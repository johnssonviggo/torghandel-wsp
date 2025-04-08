require_relative 'controller/application_controller'
require_relative 'controller/users_controller'
require_relative 'controller/listings_controller'
require_relative 'controller/admin_controller'



class App < ApplicationController
    use Rack::Session::Cookie, key: "rack.session",
                               path: "/",
                               secret: ENV["SESSION_SECRET"]

    
    set :public_folder, 'public'

    use UsersController
    use ApplicationController
    use ListingsController
    use AdminController


end
