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

      tag_ids = Database.connection.execute("SELECT tag_id FROM listing_tags WHERE listing_id=?", [listing["id"]])
      tags = tag_ids.map do |tag_id|
      Database.connection.get_first_row("SELECT name FROM tags WHERE id=?", [tag_id["tag_id"]])["name"]
      end

      listing["tags"] = tags

    end
    return listings
  end

  def self.find(id)
    Database.connection.execute("SELECT * FROM #{table_name()} WHERE id=?", [id]).first
  end

  def self.create(name, description, cost, image, owner_id, tags = [])
    Database.connection.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
                                [name, description, cost, image, owner_id])

    listing_id = Database.connection.last_insert_row_id

  tag_array = if tags.is_a?(String)
      tags.split(',').map(&:strip)
    else
      tags
    end

  tag_array.each do |tag_name|
    tag = Database.connection.get_first_row('SELECT id FROM tags WHERE name = ?', [tag_name])
    tag_id = if tag
        tag["id"]
      else
        Database.connection.execute('INSERT INTO tags (name) VALUES (?)', [tag_name])
        Database.connection.last_insert_row_id
      end

    Database.connection.execute('INSERT OR IGNORE INTO listing_tags (listing_id, tag_id) VALUES (?, ?)', [listing_id, tag_id])
  end
    return listing_id
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
