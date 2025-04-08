require_relative 'database'

class Listing < Base

  # def initialize(hash)
  #   @id = hash["id"]
  #   @name = hash["name"]
  #   @description = hash["description"]
  #   @cost = hash["cost"]
  #   @image = hash["image"]
  # end

  def self.table_name
    "listings"
  end


  def self.all
    listings = Database.connection.execute("SELECT * FROM #{table_name()}")
    # convert_to_object_array
    # return object_array
    #omvandla listings som nu är en array av hashes till en array av listings-objekt (genom att anropa new)

    listings.each do |listing|
     listing["image_url"] = listing["image"] ? "http://localhost:9292/img/#{listing['image']}" : "https://via.placeholder.com/150"
    end
    return listings
  end

  def self.find(id)
    Database.connection.execute("SELECT * FROM #{table_name()} WHERE id=?", [id]).first
  end

  def self.create(name, description, cost, image, owner_id)
    Database.connection.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
                                [name, description, cost, image, owner_id])
  end

  def self.delete(id)
    Database.connection.execute('DELETE FROM listings WHERE id=?', [id])
  end

  def self.update(id, name, description, cost, image = nil)
    if image
        Database.connection.execute('UPDATE listings SET name=?, description=?, cost=?, image=? WHERE id=?',
                                    [name, description, cost, image, id])
    else
        Database.connection.execute('UPDATE listings SET name=?, description=?, cost=? WHERE id=?',
                                    [name, description, cost, id])
    end
  end


end
