require_relative 'database'

class Listing
  def self.all
    listings = Database.connection.execute('SELECT * FROM listings')
    listings.each do |listing|
      listing["image_url"] = listing["image"] ? "http://localhost:9292/img/#{listing['image']}" : "https://via.placeholder.com/150"
    end
    return listings
  end

  def self.find(id)
    Database.connection.execute('SELECT * FROM listings WHERE id=?', [id]).first
  end

  def self.create(name, description, cost, image)
    Database.connection.execute('INSERT INTO listings (name, description, cost, image) VALUES (?, ?, ?, ?)',
                                [name, description, cost, image])
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
