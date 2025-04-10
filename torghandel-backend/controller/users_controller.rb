require_relative 'application_controller'
require_relative '../models/users'


class UsersController < ApplicationController
  FAILED_ATTEMPTS = {}
  LOCKOUT_THRESHOLD = 3
  LOCKOUT_TIME = 1 * 60


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

    attempts = FAILED_ATTEMPTS[username] ||= {count: 0, last_attempt: Time.now }

    puts attempts

    if attempts[:locked_until] && Time.now < attempts[:locked_until]
      halt 429, { message: "Too many failed attempts. Try again later." }.to_json
    end

    user = User.find_by("username", data["username"])

    puts "User from DB: #{user.inspect}"
    puts "Password from frontend: #{password}"
    puts "Hashed password: #{user}"

    hashed_password = user['password'].to_s
    bcrypt_db_pass = BCrypt::Password.new(hashed_password)

    puts "User id: #{user['id'].inspect}"
    puts "Session user_id before; #{session[:user_id]}"

    if user && bcrypt_db_pass == password
        session[:user_id] = user['id']

        FAILED_ATTEMPTS.delete(username)

        puts "Session user_id after; #{session[:user_id]}"

        content_type :json
        { message: "Login successful", user: { id: user['id'], username: user['username'] } }.to_json
    else
      attempts[:count] += 1
      attempts[:last_attempt] = Time.now

      if attempts[:count] >= LOCKOUT_THRESHOLD
        attempts[:locked_until] = Time.now + LOCKOUT_TIME
    end

      halt 401, { message: "Invalid credentials" }.to_json
    end
end

  post '/api/register' do
    data = JSON.parse(request.body.read)
    username = data["username"]
    password = data["password"]

    existing_user = User.find_by("username", data["username"])
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

  post '/api/users/:id/delete' do

    user = User.find_by("id", params[:id])

    if user
      User.delete(params[:id])

      content_type :json
      { message: "User and their listings deleted successfully" }.to_json
    else
      halt 404, { message: "User not found" }.to_json
    end
  end

end
