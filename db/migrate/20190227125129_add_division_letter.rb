class AddDivisionLetter < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :league_match, :integer
    add_column :divisions, :letter, :string
  end
end
