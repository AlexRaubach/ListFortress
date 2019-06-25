class LeagueSignup < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user, scope: :season_number
end
