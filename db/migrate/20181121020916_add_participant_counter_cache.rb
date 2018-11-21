class AddParticipantCounterCache < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :participants_cache, :integer
  end
end
