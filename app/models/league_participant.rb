class LeagueParticipant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :division
  
end
