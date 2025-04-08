class Base

  def self.find_by(field, value)
    Database.connection.execute("SELECT * FROM #{table_name()} WHERE #{field} = ?", [value]).first
  end

  def self.all
    return Database.connection.execute("SELECT * FROM #{table_name()}")
  end
end
