class AddLossOnLeagueParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :losses, :integer
  end
end
