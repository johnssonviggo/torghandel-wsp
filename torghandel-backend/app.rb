require 'json'
require 'sinatra'
require 'sinatra/cross_origin'
require 'bcrypt'

require_relative './models/users'
require_relative './models/listings'
require_relative './models/database'



class App < Sinatra::Base

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

    def db
        return @db if @db

        @db = SQLite3::Database.new("db/listings.sqlite")
        @db.results_as_hash = true

         return @db
     end

    set :public_folder, 'public'

    get '/img/:filename' do
        send_file File.join(settings.public_folder, 'img', params[:filename])
    end

    get '/api/users' do
        users = User.all
        content_type :json
        { users: users }.to_json
    end

    get '/api/listings' do
        @listings = Listing.all

        content_type :json
        {content: @listings}.to_json
    end

    get '/api/listings/:id' do
        id = params[:id]
        listing = Listing.find(params[:id])

        if listing
            content_type :json
            listing.to_json
        else
            halt 404, { message: "Listing not found" }.to_json
        end
    end

    get '/api/protected' do
        if session[:user_id]
            content_type :json
            { message: "You are authorized", user_id: session[:user_id] }.to_json
        else
            halt 401, { message: "Unauthorized" }.to_json
        end
    end

    post '/api/register' do
        data = JSON.parse(request.body.read)
        username = data["username"]
        password = data["password"]

        existing_user = User.find_by_username(username)
        if existing_user
            halt 400, { message: "Username already exists" }.to_json
        end

        User.create(username, password)

        p username
        p password

        content_type :json
        { message: "User registered successfully" }.to_json
    end


    post '/api/login' do
        data = JSON.parse(request.body.read)

        username = data["username"]
        password = data["password"]

        # user = db.execute('SELECT * FROM users WHERE username=?', [username]).first
        user = User.find_by_username(data["username"])

        if user && BCrypt::Password.new(user['password']) == data["password"]
            session[:user_id] = user['id']
            content_type :json
            { message: "Login successful", user: { id: user['id'], username: user['username'] } }.to_json
        else
            halt 401, { message: "Invalid credentials" }.to_json
        end
    end

    post '/api/listings' do
        name = params[:name]
        description = params[:description]
        cost = params[:cost]
        image_filename = ""

        # ✅ Handle image upload
        if params[:image] && params[:image][:tempfile]
          image = params[:image][:tempfile]
          image_filename = params[:image][:filename]

          # Ensure the public/img/ directory exists
          FileUtils.mkdir_p("public/img")

          # Save the image
          path = File.join("public/img", image_filename)
          File.open(path, "wb") do |file|
            file.write(image.read)
          end
        end

        # ✅ Insert data into database
        db.execute('INSERT INTO listings (name, description, cost, image) VALUES (?, ?, ?, ?)',
                   [name, description, cost, image_filename])
        content_type :json
        { message: "Listing created", image_url: "http://localhost:9292/img/#{image_filename}" }.to_json
    end

    post '/api/listings/:id/delete' do
        Listing.delete(params[:id])
        @listings = Listing.all

        content_type :json
        {content: @listings, message: "Listing deleted"}.to_json
    end

    post '/api/listings/:id/update' do
        id = params[:id]
        name = params[:name]
        description = params[:description]
        cost = params[:cost]
        image_filename = nil

        if params[:image] && params[:image][:tempfile]
            image = params[:image][:tempfile]
            image_filename = params[:image][:filename]

            FileUtils.mkdir_p("public/img")
            File.open(File.join("public/img", image_filename), "wb") { |file| file.write(image.read) }
        end

        Listing.update(id, name, description, cost, image_filename)

        content_type :json
        { message: "Listing updated successfully" }.to_json
    end

    post '/api/logout' do
        session.clear
        content_type :json
        { message: "Logged out" }.to_json
    end
end
