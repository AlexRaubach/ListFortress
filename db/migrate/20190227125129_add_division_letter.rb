class AddDivisionLetter < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :league_match, :boolean
    add_column :matches, :player1_url, :string
    add_column :matches, :player2_url, :string
    add_column :divisions, :letter, :string
  end
end
