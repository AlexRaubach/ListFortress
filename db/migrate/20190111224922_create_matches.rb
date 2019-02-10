class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.references :player1, polymorphic: true, index: true
      t.integer :player1_points
      t.column :player1_xws, 'jsonb'

      t.references :player2, polymorphic: true, index: true
      t.integer :player2_points
      t.column :player2_xws, 'jsonb'

      t.references :round, foreign_key: true
      t.string :result
      t.references :winner, polymorphic: true, index: true
      t.string :logfile_url
      t.integer :match_state
      t.datetime :scheduled_time

      t.timestamps
    end
  end
end
