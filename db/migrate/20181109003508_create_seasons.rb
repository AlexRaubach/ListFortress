class CreateSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :seasons do |t|
      t.string :name
      t.integer :season_number, unique: true
      t.boolean :active
      t.boolean :sign_up_active
      t.boolean :locked

      t.timestamps
    end
  end
end
