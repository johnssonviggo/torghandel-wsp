require 'sqlite3'

##
# The Database class provides a singleton-style interface to the SQLite3 database.
# It initializes and returns a shared database connection used across the application.
#
# This class ensures that only one instance of the database connection is created and reused.
#
class Database
  
  # Returns the SQLite3 database connection. If the connection has not been
  # established yet, it will create a new one and enable hash-style result access.
  #
  # @return [SQLite3::Database] The SQLite3 database connection object.
  def self.connection
    return @db if @db

    @db = SQLite3::Database.new("db/listings.sqlite")
    @db.results_as_hash = true

    return @db
  end
end
