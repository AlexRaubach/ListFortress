class CreatePilots < ActiveRecord::Migration[5.2]
  def change
    create_table :pilots do |t|
      t.string :name
      t.string :caption
      t.integer :initiative
      t.boolean :limited
      t.integer :cost
      t.string :xws
      t.integer :ffg
      t.integer :ship_id
      t.string :image
      t.string :ability
      t.index :xws

    end
  end
end
