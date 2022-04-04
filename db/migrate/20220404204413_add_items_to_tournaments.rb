class AddItemsToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :event_points, :integer
    add_column :participants, :mission_points, :integer
    add_column :matches, :rounds_played, :integer
    add_column :matches, :went_to_time, :boolean
    add_column :rounds, :scenario, :string
  end
end
