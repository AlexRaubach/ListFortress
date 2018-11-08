class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.int :league_player_id
      t.string :first_line
      t.string :second_line
      t.string :city
      t.string :county_province
      t.string :zip_or_postcode
      t.string :country
      t.string :other

      t.timestamps
    end
  end
end
