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
    db.execute('DROP TABLE IF EXISTS listing_tags')
    db.execute('DROP TABLE IF EXISTS listings')
    db.execute('DROP TABLE IF EXISTS tags')

    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS admin')

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

    db.execute('CREATE TABLE tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE)')

    db.execute('CREATE TABLE listing_tags(
            listing_id INTEGER NOT NULL,
            tag_id INTEGER NOT NULL,
            FOREIGN KEY (listing_id) REFERENCES listings(id),
            FOREIGN KEY (tag_id) REFERENCES tags(id),
            PRIMARY KEY (listing_id, tag_id)
          )')
  end

  def self.populate_tables
    password_hashed = BCrypt::Password.create("d1npiZZ4!")
    admin_password_hashed = BCrypt::Password.create("Admin!1")

    db.execute('INSERT INTO users (username, password) VALUES (?,?)', ["Viggo", password_hashed])
    @owner_id = db.last_insert_row_id


    db.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
    ["GAMMAL SAAB", "Rostig men fungerar fantastiskt", "10000", "garbage_truck.jpg", @owner_id])

    listing_id = db.last_insert_row_id


    db.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
    ["BANANSKAL", "Gult skal", "100000", "", @owner_id])

    listing_id = db.last_insert_row_id


    tags = ["bil", "mat", "skräp"]

    tags.each do |tag_name|
      #Check if tag exist
      tag = db.get_first_row('SELECT id FROM tags WHERE name=?', [tag_name])

      if tag
        tag_id = tag["id"]
      else
        db.execute('INSERT INTO tags (name) VALUES (?)', [tag_name])
        tag_id = db.last_insert_row_id
      end

      #Insert into listings_tag
      db.execute('INSERT INTO listing_tags (listing_id, tag_id) VALUES (?,?)', [listing_id, tag_id])
    end

    db.execute('INSERT OR IGNORE INTO admin (admin_name, admin_password) VALUES (?,?)', ["Admin", admin_password_hashed])

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
