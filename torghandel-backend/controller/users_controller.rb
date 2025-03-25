require_relative 'application_controller'
require_relative '../models/users'

class UsersControllers < ApplicationController
  get '/api/users' do
    users = User.all
    content_type :json
    { users: users }.to_json
  end

  post '/api/login' do
      data = JSON.parse(request.body.read)
      user = User.find_by_username(data["username"])

      if user && BCrypt::Password.new(user['password']) == data["password"]
          session[:user_id] = user['id']
          content_type :json
          { message: "Login successful", user: { id: user['id'], username: user['username'] } }.to_json
      else
          halt 401, { message: "Invalid credentials" }.to_json
      end
  end

  post '/api/logout' do
      session.clear
      content_type :json
      { message: "Logged out" }.to_json
  end
end
