class Season < ApplicationRecord
  has_many :divisions
  has_many :league_participants, through: :divisions
  validates_uniqueness_of :season_number

  CURRENT_SEASON = 12 # used for user.current_league_participant
  CURRENT_SIGNUP_NUMBER = 12 # used in league signup logic i.e. league_signups_controller and league home page
  SIGNUPS_OPEN = true
  INTERDIVISIONAL_ALLOWED = false

  def self.add_participant(season_number, user_id, div_tier, div_letter)
    season = Season.find_by(season_number: season_number)
    division = Division.find_by(tier: div_tier, letter: div_letter, season_id: season.id)

    if division.nil?
      puts "Nil division #{div_tier} #{div_letter}"
      return
    end

    league_participant = LeagueParticipant.create(user_id: user_id)
    division.add_participant(league_participant)
  end

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
