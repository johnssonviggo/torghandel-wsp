require 'bcrypt'
require_relative 'database'
require_relative 'base'

class User < Base
attr_accessor :id, :username, :password

  def initialize(id, username, password)
    @id = id
    @username = username
    @password = password
    var = "users"
  end

  def self.table_name
    "users"
  end


  # def self.all
  #   return Database.connection.execute("SELECT * FROM #{table_name()}")
  # end

  # def self.find_by_username(username)
  #   Database.connection.execute('SELECT * FROM users WHERE username=?', [username]).first
  # end

  def self.create(username, password)
    hashed_password = BCrypt::Password.create(password)
    Database.connection.execute('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashed_password])
  end
end
