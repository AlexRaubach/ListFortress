class AddLookupIndexes < ActiveRecord::Migration[7.2]
  def change
    # The API's updatedafter filter, used by MetaWing's sync
    add_index :tournaments, :updated_at
    # League pages look participants up by user and by division
    add_index :league_participants, :user_id
    add_index :league_participants, :division_id
    add_index :divisions, :season_id
  end
end
