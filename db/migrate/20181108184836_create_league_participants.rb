class CreateLeagueParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :league_participants do |t|
      t.integer league_user_id
      t.integer season_id

      t.timestamps
    end
  end
end
