class CreateUpgrades < ActiveRecord::Migration[5.2]
  def change
    create_table :upgrades do |t|
      t.string :name
      t.string :xws
      t.integer :ffg
      t.string :type
      t.boolean :limited
      t.string :image
      t.integer :cost

      t.timestamps
    end
  end
end
