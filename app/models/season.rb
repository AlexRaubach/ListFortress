class Season < ApplicationRecord
  has_many :divisions
  has_many :league_participants, through: :divisions

  def to_param
    season_number
  end
end
