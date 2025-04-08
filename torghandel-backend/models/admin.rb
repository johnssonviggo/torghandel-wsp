require 'bcrypt'
require_relative 'database'

class Admin < Base
attr_accessor :id, :admin_name, :admin_password

  def initialize(id, admin_name, admin_password)
    @id = id
    @admin_name = admin_name
    @admin_password = admin_password
  end

  def self.table_name
    "admin"
  end


  # def self.all
  #   return Database.connection.execute("SELECT * FROM #{table_name}")
  # end

  # def self.find_by_username(admin_name)
  #   Database.connection.execute('SELECT * FROM admin WHERE admin_name=?', [admin_name]).first
  # end

  def self.create(admin_name, admin_password)
    admin_password_hashed = BCrypt::Password.create(admin_password)
    Database.connection.execute('INSERT INTO admin (admin_name, admin_password) VALUES (?, ?)', [admin_name, admin_password_hashed])
  end

end
