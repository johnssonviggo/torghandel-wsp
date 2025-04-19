require 'bcrypt'
require_relative 'database'
require_relative 'base'

##
# The User class represents users in the application and maps to the `users` table in the database.
# It inherits common ORM-like functionality from the `Base` class and adds custom create and delete methods.
#
class User < Base
attr_accessor :id, :username, :password


  # Initializes a new User instance.
  #
  # @param id [Integer] the user ID
  # @param username [String] the username
  # @param password [String] the password (already hashed or raw; not used to log in)
  def initialize(id, username, password)
    @id = id
    @username = username
    @password = password
    var = "users"
  end


  # Returns the name of the associated table in the database.
  #
  # @return [String] the table name ("users")
  def self.table_name
    "users"
  end


  # Creates a new user with a securely hashed password.
  #
  # @param username [String] the desired username
  # @param password [String] the plaintext password (will be hashed)
  def self.create(username, password)
    hashed_password = BCrypt::Password.create(password)
    Database.connection.execute('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashed_password])
  end

  
  # Deletes a user by ID.
  #
  # @param id [Integer] the ID of the user to delete
  def self.delete(id)
    Database.connection.execute('DELETE FROM users WHERE id = ?', [id])
  end
end
