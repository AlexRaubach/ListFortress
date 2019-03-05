class ChangeShipXws < ActiveRecord::Migration[5.2]
  def change
    change_column :ships, :xws, :string
  end
end
