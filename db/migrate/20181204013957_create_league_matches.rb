class CreateLeagueMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :leage_matches do |t|
      t.integer :p1_id
      t.column :p1_list_json, 'jsonb'
      t.string :p1_lj_list_string
      t.string :p1_list_url

      t.integer :p2_id
      t.column :p2_list_json, 'jsonb'
      t.string :p2_lj_list_string
      t.string :p2_list_url

      t.integer :division_id
      t.integer :match_state_id
      t.integer :legacy_match_id
      t.date :scheduled_time



      t.timestamps
    end
  end
end
