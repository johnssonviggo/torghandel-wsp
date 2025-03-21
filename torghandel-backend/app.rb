require 'json'
require 'sinatra'
require 'sinatra/cross_origin'
require 'bcrypt'



class App < Sinatra::Base

    configure do
        enable :cross_origin
    end

    before do
        response.headers['Access-Control-Allow-Origin'] = '*'
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

    get '/api/message' do
        p "  API call to /api/message"
        content_type :json
        { message: "Hello from Sinatra!" }.to_json
    end

    get '/api/anothermessage' do
        # p " API call to /api/anothermessage"
        content_type :json
        {message: "Hello from Viggo." + " Jag testar lite grejer"}.to_json
    end

    get '/api/users' do
        users = db.execute('SELECT id, username FROM users')  # Exclude password
        content_type :json
        { users: users }.to_json
    end

    get '/api/listings' do
        @listings = db.execute('SELECT * FROM listings')

        # @listings.each do |listing|
        #     listing["image_url"] = "/img/#{listing['image']}"
        # end

        @listings.each do |listing|
            if listing["image"] && !listing["image"].empty?
              listing["image_url"] = "http://localhost:9292/img/#{listing['image']}"
            else
              listing["image_url"] = "https://via.placeholder.com/150"  # Placeholder image
            end
          end

        p @listings

        content_type :json
        {content: @listings}.to_json

    end

    get '/api/listings/:id' do
        id = params[:id]
        listing = db.execute('SELECT * FROM listings WHERE id=?', [id]).first

        if listing
            listing["image_url"] = listing["image"] ? "http://localhost:9292/img/#{listing['image']}" : "https://via.placeholder.com/150"
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

    # post '/api/register' do
    #     username = params[:username]
    #     password = params[:password]

    #     existing_user = db.execute('SELECT * FROM users WHERE username=?', [username]).first
    #     if existing_user
    #         halt 400, { message: "Username already exists" }.to_json
    #     end

    #     hashed_password = BCrypt::Password.create(password)
    #     db.execute('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashed_password])

    #     content_type :json
    #     { message: "User registered successfully" }.to_json
    # end


    post '/api/login' do
        data = JSON.parse(request.body.read)
        p data

        username = data["username"]
        password = data["password"]

        user = db.execute('SELECT * FROM users WHERE username=?', [username]).first
        p username
        p password
        p user

        if user && BCrypt::Password.new(user['password']) == password
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

        id = params[:id]
        db.execute('DELETE FROM listings WHERE id=?', [id])

        @listings = db.execute('SELECT * FROM listings')

  # Optionally, you can include the images as you did in the previous code
        @listings.each do |listing|
          if listing["image"] && !listing["image"].empty?
            listing["image_url"] = "http://localhost:9292/img/#{listing['image']}"
          else
            listing["image_url"] = "https://via.placeholder.com/150"
          end
        end

        content_type :json
        {content: @listings}.to_json
        {message: "Listing deleted"}.to_json
    end

    post '/api/listings/:id/update' do
        p params # Print params to debug
        id = params[:id]
        p "ID received: #{id}" # ✅ Print the ID to debug

        if id.nil? || id.strip.empty?
            halt 400, { message: "Invalid ID" }.to_json # ✅ Stop if ID is missing
        end

        name = params[:name]
        description = params[:description]
        cost = params[:cost]
        image_filename = nil

        if params[:image] && params[:image][:tempfile]
            image = params[:image][:tempfile]
            image_filename = params[:image][:filename]

            FileUtils.mkdir_p("public/img")
            path = File.join("public/img", image_filename)

            File.open(path, "wb") do |file|
                file.write(image.read)
            end

            db.execute('UPDATE listings SET name=?, description=?, cost=?, image=? WHERE id=?',
                       [name, description, cost, image_filename, id])
        else
            db.execute('UPDATE listings SET name=?, description=?, cost=? WHERE id=?',
                       [name, description, cost, id])
        end

        content_type :json
        { message: "Listing updated successfully" }.to_json
    end

    post '/api/logout' do
        session.clear
        content_type :json
        { message: "Logged out" }.to_json
    end
end
