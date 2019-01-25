class CreateDivisions < ActiveRecord::Migration[5.2]
  def change
    create_table :divisions do |t|
      t.string :name
      t.integer :season_id
      t.integer :tier
      

      t.timestamps
    end
  end
end
