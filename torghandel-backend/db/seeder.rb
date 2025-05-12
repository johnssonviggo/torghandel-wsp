require 'sqlite3'
require 'bcrypt'
require_relative "../models/users"
require_relative "../models/listings"
require_relative "../models/admin"

##
# Seeder class handles resetting and populating the database
# with example data, including users, listings, and tags.
#
class Seeder

  # Main method to initialize the full seed process:
  # Drops all existing tables, creates fresh ones, and populates them with starter data.
  #
  # @return [void]
  #
  def self.seed!
    drop_tables
    create_tables
    populate_tables

    p "doit"
  end

  # Drops all tables if they exist.
  # Tables: 'listing_tags', 'listings', 'tags', 'users', 'admin'
  #
  # @return [void]
  #
  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS listing_tags')
    db.execute('DROP TABLE IF EXISTS listings')
    db.execute('DROP TABLE IF EXISTS tags')

    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS admin')

  end

  # Creates all the tables for the application:
  # 'users', 'listings', 'admin', 'tags', 'listing_tags'
  #
  # @return [void]
  #
  def self.create_tables
    db.execute('CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL)')

    db.execute('CREATE TABLE listings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            name TEXT NOT NULL,
            description TEXT,
            cost NUMBER NOT NULL,
            image FILE NOT NULL
            )')

    db.execute('CREATE TABLE admin (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            admin_name TEXT NOT NULL,
            admin_password TEXT NOT NULL)')

    db.execute('CREATE TABLE tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE)')

    db.execute('CREATE TABLE listing_tags(
            listing_id INTEGER NOT NULL,
            tag_id INTEGER NOT NULL,
            FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE,
            FOREIGN KEY (tag_id) REFERENCES tags(id),
            PRIMARY KEY (listing_id, tag_id)
          )')
  end

  # Populates the database with example users, listings, and tags.
  # Also hashes and inserts user and admin credentials.
  #
  # @return [void]
  #
  def self.populate_tables

    @owner_id = User.create("Viggo", "d1npiZZ4!")
    Admin.create("Admin", "Admin!1")

    # add first listing
    Listing.create("GAMMAL SAAB", "Rostig men fungerar fantastiskt", "10000", "garbage_truck.jpg", @owner_id, ["bil", "skräp"])

    # listing_id = db.last_insert_row_id
    # add_tags_to_listing(listing_id, ["bil", "skräp"])

    # # add second listing
    Listing.create("BANANSKAL", "Gult skal", "100000", "", @owner_id, ["mat", "skräp"])

    # listing_id = db.last_insert_row_id
    # add_tags_to_listing(listing_id, ["mat", "skräp"])
  end


  # Links tag names to a given listing by inserting records
  # into `tags` and `listing_tags` tables.
  #
  # @param listing_id [Integer] the ID of the listing
  # @param tag_names [Array<String>] list of tag names to associate
  # @return [void]
  #
  # def self.add_tags_to_listing(listing_id, tag_names)
  #  Listing.create
  # end

  private
  # Returns or initializes the SQLite database connection.
  # Ensures foreign key support is enabled and results are returned as hashes.
  #
  # @return [SQLite3::Database] configured SQLite3 connection
  #
  def self.db
    Database.connection
  end
end

# Starts seeding process
Seeder.seed!
