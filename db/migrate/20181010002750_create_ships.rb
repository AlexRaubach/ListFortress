class CreateShips < ActiveRecord::Migration[5.2]
  def change
    create_table :ships do |t|
      t.string :name
      t.integer :ffg
      t.string :size
      t.integer :xws
      t.integer :faction_id
      t.index :xws

      t.timestamps
    end
  end
end
