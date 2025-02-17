require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
    p "doit"
  end

    def self.drop_tables
      db.execute('DROP TABLE IF EXISTS listings')
    end

    def self.create_tables
      db.execute('CREATE TABLE listings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              cost TEXT NOT NULL)')
    end

    def self.populate_tables
      db.execute('INSERT INTO listings (name, description, cost) VALUES ("GAMMAL SAAB", "Rostig men fungerar fantastiskt", "10000")')
    end

    private
      def self.db
        return @db if @db
        @db = SQLite3::Database.new('db/listings.sqlite')
    @db.results_as_hash = true
    @db
  end
end

Seeder.seed!
