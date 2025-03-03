require 'json'
require 'sinatra'
require 'sinatra/cross_origin'


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

    get '/login' do
        "hej svejs"
        content_type :json
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

    post '/api/listings' do
        # data = JSON.parse(request.body.read)

        # p data

        # name = data["name"]
        # description = data["description"]
        # cost = data["cost"]

        # fp = data["image"]

        # p fp

        #path = File.join("./public/img/",data["file"])

       # File.write(path,File.read(params[:file][:tempfile]))
       # db.execute('INSERT INTO listings (name, description, cost, image) VALUES (?,?,?,?)',
       #             [name, description, cost, image])
       # {content: @listings}.to_json

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


end
