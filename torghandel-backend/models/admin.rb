require 'bcrypt'
require_relative 'database'

##
# Represents an Admin user in the application. Inherits from Base.
# Provides functionality for creating admin users with hashed passwords.
#
# @!attribute id
#   @return [Integer] The unique identifier of the admin.
# @!attribute admin_name
#   @return [String] The name/username of the admin.
# @!attribute admin_password
#   @return [String] The hashed password of the admin.
#
class Admin < Base
attr_accessor :id, :admin_name, :admin_password


  # Creates a new Admin instance.
  #
  # @param id [Integer] The ID of the admin.
  # @param admin_name [String] The name/username of the admin.
  # @param admin_password [String] The hashed password of the admin.
  def initialize(id, admin_name, admin_password)
    @id = id
    @admin_name = admin_name
    @admin_password = admin_password
  end



  # REturns the table_name admin
  #
  # @return the name of the table
  def self.table_name
    "admin"
  end


  # def self.all
  #   return Database.connection.execute("SELECT * FROM #{table_name}")
  # end

  # def self.find_by_username(admin_name)
  #   Database.connection.execute('SELECT * FROM admin WHERE admin_name=?', [admin_name]).first
  # end


  # Creates a new admin user in the database with a securely hashed password.
  #
  # @param admin_name [String] The name/username of the new admin.
  # @param admin_password [String] The plaintext password to hash and store.
  # @return [void]
  def self.create(admin_name, admin_password)
    admin_password_hashed = BCrypt::Password.create(admin_password)
    Database.connection.execute('INSERT INTO admin (admin_name, admin_password) VALUES (?, ?)', [admin_name, admin_password_hashed])
  end
end
