require_relative 'database'

##
# The Base class acts as a simple ORM superclass.
# Subclasses must implement the `self.table_name` method to provide
# their corresponding table name in the database.
#
# Provides common database query methods like `.find_by` and `.all`.
#
class Base

  def self.db
    Database.connection
  end


  # Finds the first record in the database matching a specific field and value.
  #
  # @param field [String, Symbol] The name of the column to search by.
  # @param value [Object] The value to match in the specified field.
  # @return [Hash, nil] The first matching record as a hash, or nil if none found.
  def self.find_by(field, value)
    db.execute("SELECT * FROM #{table_name()} WHERE #{field} = ?", [value]).first
  end

  def self.find(value)
    find_by("id", value)
  end


  # Retrieves all records from the database table.
  #
  # @return [Array<Hash>] An array of all records as hashes.
  def self.all
    db.execute("SELECT * FROM #{table_name()}")
  end

  # Deletes a listing by its ID.
  #
  # @param id [Integer] the ID of the table_name to delete
  def self.delete(id)
    db.execute("DELETE FROM #{table_name} WHERE id=?", [id])
  end

end
