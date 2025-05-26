require_relative 'database'
##
# The Tag class handles all database interactions related to tags,
# including creating and associating tags with listings.
#
# Inherits from the Base class, which likely provides a `db` method
# and other common ORM functionality.
#

class Tag < Base

  ##
  # Returns the name of the table associated with this model.
  #
  # @return [String] the table name: "tags"
  #
  def self.table_name
    "tags"
  end

  ##
  # Creates and associates tags with a given listing.
  #
  # @param tags [Array<String>, String] the tags to create or associate. Can be an array of tag names or a comma-separated string.
  # @param listing_id [Integer] the ID of the listing to associate the tags with.
  # @return [void]
  #
  def self.create(tags = [], listing_id)
    tag_array = if tags.is_a?(String)
      tags.split(',').map(&:strip)
    else
      tags
    end

    tag_array.each do |tag_name|

      tag = db.get_first_row("SELECT id FROM #{table_name} WHERE name = ?", [tag_name])

      tag_id = if tag
          tag["id"]
        else
          db.execute("INSERT INTO #{table_name} (name) VALUES (?)", [tag_name])
          db.last_insert_row_id
        end

        db.execute('INSERT OR IGNORE INTO listing_tags (listing_id, tag_id) VALUES (?, ?)', [listing_id, tag_id])
      end
  end

end
