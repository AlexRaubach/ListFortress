class Division < ApplicationRecord
  belongs_to :season
  has_many :league_participants

  def add_participant(participant)
    division_members = LeagueParticipant.where(division_id: id)

    if division_members.length.positive?
      division_members.each do |division_member|
        Match.create(player1: participant, player2: division_member)
      end
    end

    participant.division_id = id
    participant.save
  end
end
