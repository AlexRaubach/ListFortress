class AddPromotionTrackerToLeagueParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :league_participants, :promotion, :integer
  end
end
