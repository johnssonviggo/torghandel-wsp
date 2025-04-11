require 'sqlite3'
require 'bcrypt'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables

    p "doit"
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS listings')

    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS admin')

    db.execute('DROP TABLE IF EXISTS tags')
    db.execute('DROP TABLE IF EXISTS listing_tags')
  end

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

    # db.execute('CREATE TABLE tags (
    #   id INTEGER PRIMARY KEY AUTOINCREMENT,
    #   name TEXT NOT NULL UNIQUE)')

    #   db.execute('CREATE TABLE listing_tags(
    #     listing_id INTEGER NOT NULL,
    #     tag_id INTEGER NOT NULL,
    #     FOREIGN KEY (listing_id) REFERENCES listings(id),
    #     FOREIGN KEY (tag_id) REFERENCES tags(id),
    #     PRIMARY KEY (listing_id, tag_id)),
    #     tag_name TEXT NOT NULL')
  end

  def self.populate_tables
    password_hashed = BCrypt::Password.create("d1npiZZ4!")
    admin_password_hashed = BCrypt::Password.create("Admin!1")
    db.execute('INSERT INTO users (username, password) VALUES (?,?)', ["Viggo", password_hashed])
    @owner_id = db.last_insert_row_id


    db.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
    ["GAMMAL SAAB", "Rostig men fungerar fantastiskt", "10000", "garbage_truck.jpg", @owner_id])

    db.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
    ["BANANSKAL", "Gult skal", "100000", "", @owner_id])

    db.execute('INSERT INTO admin (admin_name, admin_password) VALUES (?,?)', ["Admin", admin_password_hashed])


      # db.execute('INSERT INTO listing')
      # tags = ["Car", "Rusty", "Yellow", "Luxury"]
      # tags.each { |tag| db.execute('INSERT OR IGNORE INTO tags (name) VALUES (?)', [tag]) }

      # listing_tags = [
      #   [1, "Car"],    # GAMMAL SAAB -> Car
      #   [1, "Rusty"],  # GAMMAL SAAB -> Rusty
      #   [2, "Yellow"], # BANANSKAL -> Yellow
      #   [2, "Luxury"]  # BANANSKAL -> Luxury
      # ]

      # listing_tags.each do |listing_id, tag_name|
      #   tag_id = db.execute('SELECT id FROM tags WHERE name = ?', [tag_name]).first&.dig("id")
      #   db.execute('INSERT INTO listing_tags (listing_id, tag_id, tag_name) VALUES (?, ?, ?)', [listing_id, tag_id, tag_name]) if tag_id
      # end
  end

  private

  def self.db
    return @db if @db

    @db = SQLite3::Database.new('db/listings.sqlite')
    @db.results_as_hash = true
    @db.execute("PRAGMA foreign_keys = ON;")
    @db
  end
end

Seeder.seed!
