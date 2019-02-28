class AddDivisionLetter < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :league_match, :integer
    add_column :league_participants, :player1_url, :string
    add_column :league_participants, :player2_url, :string
    add_column :divisions, :letter, :string
  end
end
