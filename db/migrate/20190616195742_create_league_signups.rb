class CreateLeagueSignups < ActiveRecord::Migration[5.2]
  def change
    create_table :league_signups do |t|
      t.integer :season_number
      t.integer :user_id
      t.string :time_zone
      t.integer :time
      t.string :other

      t.timestamps
    end
  end
end
