class LeagueParticipant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :division
  has_many :matches, as: :player_1
  has_many :matches, as: :player_2
  has_many :matches, as: :winner

end
