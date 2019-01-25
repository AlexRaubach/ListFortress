class CreateLeagueMatchStates < ActiveRecord::Migration[5.2]
  def change
    create_table :league_match_states do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
