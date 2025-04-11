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

  def self.create(username, password)
    hashed_password = BCrypt::Password.create(password)
    Database.connection.execute('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashed_password])
  end

  def self.delete(id)
    Database.connection.execute('DELETE FROM users WHERE id = ?', [id])
  end
end
