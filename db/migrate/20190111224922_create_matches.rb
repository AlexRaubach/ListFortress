class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.references :player1
      t.integer :player1_points
      t.references :player2
      t.integer :player2_points
      t.references :round, foreign_key: true
      t.string :result 
      t.references :winner
      
      t.timestamps
    end

    add_foreign_key :matches, :participants, column: :player1_id, primary_key: :id
    add_foreign_key :matches, :participants, column: :player2_id, primary_key: :id
    add_foreign_key :matches, :participants, column: :winner_id, primary_key: :id
  end
end
