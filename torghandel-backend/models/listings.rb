require_relative 'database'
require_relative 'tags'

##
# The Listing class provides methods to interact with the `listings` table in the database.
# It includes CRUD operations and manages associations between listings and tags.
#
# Inherits from `Base`, which provides shared ORM-like functionality (e.g. `.find_by`).
#
class Listing < Base

  # Returns the name of the table associated with this class.
  #
  # @return [String] the name of the table
  def self.table_name
    "listings"
  end

  # Fetches all listings from the database, and appends associated tags and image URLs to each listing.
  #
  # @return [Array<Hash>] an array of listing hashes, each with additional `tags` and `image_url` keys.
  def self.all

    listings = super #Database.connection.execute("SELECT * FROM #{table_name()}")
    # convert_to_object_array
    # return object_array
    #omvandla listings som nu är en array av hashes till en array av listings-objekt (genom att anropa new)

    listings.each do |listing|
      listing["image_url"] = listing["image"] != "" ? "http://localhost:9292/img/#{listing['image']}" : "https://placehold.co/150"

      tag_ids = db.execute("SELECT tag_id FROM listing_tags WHERE listing_id=?", [listing["id"]])
      tags = tag_ids.map do |tag_id|
      db.get_first_row("SELECT name FROM tags WHERE id=?", [tag_id["tag_id"]])["name"]
      end

      listing["tags"] = tags

    end
    return listings
  end

  # Creates a new listing with optional tags.
  #
  # @param name [String] the listing name
  # @param description [String] the listing description
  # @param cost [Numeric] the cost of the listing
  # @param image [String] image filename or URL
  # @param owner_id [Integer] the ID of the listing's owner
  # @param tags [Array<String>, String] tags as an array or comma-separated string
  #
  # @return [Integer] the ID of the newly created listing
  def self.create(name, description, cost, image, owner_id, tag_array)
    db.execute('INSERT INTO listings (name, description, cost, image, owner_id) VALUES (?, ?, ?, ?, ?)',
                                [name, description, cost, image, owner_id])

    listing_id = db.last_insert_row_id


    Tag.create(tag_array, listing_id)
  end


  # Deletes a listing by its ID.
  #
  # @param id [Integer] the ID of the listing to delete
  def self.delete(id)
    db.execute("DELETE FROM #{table_name} WHERE id=?", [id])
  end

  # Updates an existing listing.
  #
  # @param id [Integer] the listing ID
  # @param name [String] new name
  # @param description [String] new description
  # @param cost [Numeric] new cost
  # @param image [String, nil] new image if provided
  def self.update(id, name, description, cost, image = nil)

    if image
        db.execute('UPDATE listings SET name=?, description=?, cost=?, image=? WHERE id=?',
                                    [name, description, cost, image, id])
    else
        db.execute('UPDATE listings SET name=?, description=?, cost=? WHERE id=?',
                                    [name, description, cost, id])
    end
  end
end
