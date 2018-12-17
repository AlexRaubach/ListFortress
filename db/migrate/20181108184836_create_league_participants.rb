class CreateLeagueParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :league_participants do |t|
      t.integer :user_id
      t.integer :division_id
      t.integer :list_juggler_id
      t.string :list_juggler_name

      t.timestamps
    end
  end
end
