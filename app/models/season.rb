class Season < ApplicationRecord
  has_many :divisions
  has_many :league_participants, through: :divisions
  validates_uniqueness_of :season_number

  CURRENT_SEASON = 11 # used for user.current_league_participant
  CURRENT_SIGNUP_NUMBER = 11 # used in league signup logic i.e. league_signups_controller and league home page
  SIGNUPS_OPEN = true
  INTERDIVISIONAL_ALLOWED = false

  def to_param
    season_number
  end

  def to_csv
    header = %w[user_id id name score losses
                mov division_id division_name
                division_tier division_letter]

    CSV.generate(headers: true) do |csv|
      csv << header

      divisions.each do |division|
        division.league_participants.each do |player|
          output = [player.user.id, player.id, player.name, player.score, player.losses,
                    player.mov, division.id, division.name,
                    division.tier, division.letter]
          csv << output
        end
      end
    end
  end
end
