require 'sqlite3'

class Database
  def self.connection
    return @db if @db

    @db = SQLite3::Database.new("db/listings.sqlite")
    @db.results_as_hash = true

    return @db
  end
end
