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
        content_type :json
        {content: @listings}.to_json

    end

    post '/api/listings' do
        data = JSON.parse(request.body.read)
        name = data["name"]
        description = data["description"]
        cost = data["cost"]
        path = File.join("./public/img/",params[:file][:filename])
        File.write(path,File.read(params[:file][:tempfile]))
        db.execute('INSERT INTO listings (name, description, cost, image) VALUES (?,?,?,?)',
                    [name, description, cost, image])
        {content: @listings}.to_json
    end


end
