class AddParticipantCounterCache < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :participants_count, :integer, null: false, default: 0
  end
end
