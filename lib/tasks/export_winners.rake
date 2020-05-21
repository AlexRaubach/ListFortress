desc 'Creates a csv with all winners from a season'
task export_winners: :environment do
  file = "#{Rails.root}/tmp/prizes.csv"

  winners = []


  Season.where('season_number in (?)', [7, 8, 9]).each do |season|
    season.divisions.each do |div|
      if div.tier == 1
        div.league_participants.each { |lp| winners << lp }
      else
        div.league_participants
          .order(score: :desc, mov: :desc, id: :asc)
          .limit(1).each { |lp| winners << lp }
      end
    end
  end

  CSV.open(file, 'w') do |csv|
    csv << [
      'user_id', 'lp id', 'Public Name', 'Div tier',
      'Div Letter', 'Season Number', 'Full Name',
      'Email', 'street 1', 'street 2', 'city',
      'province/state', 'zip', 'country'
    ]
    winners.each do |lp|
      csv << [
        lp&.user&.id, lp.id, lp.name, lp.division.tier, lp.division.letter,
        lp.division.season.season_number, lp.user.name, lp.user.email,
        lp&.user&.address&.first_line,
        lp&.user&.address&.second_line, lp&.user&.address&.city,
        lp&.user&.address&.county_province, lp&.user&.address&.zip_or_postcode,
        lp&.user&.address&.country
      ]
    end
  end
end
