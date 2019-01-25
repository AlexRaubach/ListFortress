class CreateSeasonSevenSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :season_seven_surveys do |t|
      t.integer :user_id
      t.string :full_name
      t.string :display_name
      t.string :time_zone
      t.integer :time

      t.integer :s1_id
      t.integer :s2_id
      t.integer :s3_id
      t.integer :s4_id
      t.integer :s5_id
      t.integer :s6_id

      t.timestamps
    end
  end
end
