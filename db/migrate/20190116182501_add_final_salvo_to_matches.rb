class AddFinalSalvoToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :final_salvo, :integer
    add_reference :matches, :final_salvo_winner, index: true
    add_foreign_key :matches, :participants, column: :final_salvo_winner_id, primary_key: :id
  end
end
