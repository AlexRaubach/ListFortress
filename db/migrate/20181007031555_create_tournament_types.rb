class CreateTournamentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :tournament_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
