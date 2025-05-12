require_relative 'database'

class Tag < Base

  def self.table_name
    "tags"
  end

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
