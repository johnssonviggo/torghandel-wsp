require_relative 'application_controller'
require_relative '../models/users'

class UsersController < ApplicationController
  get '/api/users' do
    users = User.all
    content_type :json
    { users: users }.to_json
  end

  get '/api/protected' do
    if session[:user_id]
        content_type :json
        { message: "You are authorized", user_id: session[:user_id] }.to_json
    else
        halt 401, { message: "Unauthorized" }.to_json
    end
  end

  post '/api/login' do
    data = JSON.parse(request.body.read)

    username = data["username"]
    password = data["password"]

    user = User.find_by_username(data["username"])

    if user && BCrypt::Password.new(user['password']) == data["password"]
        session[:user_id] = user['id']
        session[:admin_id] = nil
        
        content_type :json
        { message: "Login successful", user: { id: user['id'], username: user['username'] } }.to_json
    else
        halt 401, { message: "Invalid credentials" }.to_json
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

  post '/api/logout' do
      session.clear
      content_type :json
      { message: "Logged out" }.to_json
  end
end
