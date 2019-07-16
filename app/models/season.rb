class Season < ApplicationRecord
  has_many :divisions
  has_many :league_participants, through: :divisions

  CURRENT_SEASON = 8

  def to_param
    season_number
  end

  def current_season?
    season_number == CURRENT_SEASON
  end

  def to_csv
    header = %w[id name score losses
                mov division_id division_name
                division_tier division_letter]

    CSV.generate(headers: true) do |csv|
      csv << header

      divisions.each do |division|
        division.league_participants.each do |player|
          output = [player.id, player.name, player.score, player.losses,
                    player.mov, division.id, division.name,
                    division.tier, division.letter]
          csv << output
        end
      end
    end
  end
end
