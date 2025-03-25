require 'bcrypt'
require_relative 'database'

class User
attr_accessor :id, :username, :password

  def initialize(id, username, password)
    @id = id
    @username = username
    @password = password
  end

  def self.all
    return Database.connection.execute('SELECT id, username FROM users')
  end

  def self.find_by_username(username)
    Database.connection.execute('SELECT * FROM users WHERE username=?', [username]).first
  end

  def self.create(username, password)

  end

end
