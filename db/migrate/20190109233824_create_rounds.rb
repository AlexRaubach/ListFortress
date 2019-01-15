class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.references :roundtype, foreign_key: true
      t.integer :round_number
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
