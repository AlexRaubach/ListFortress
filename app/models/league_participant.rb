class LeagueParticipant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :division
  belongs_to :season

end
