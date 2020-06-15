desc 'Assign all promotions and demotions'
task assign_league_promotions: :environment do
  season = Season.find_by(season_number: 9)

  season.divisions.each do |division|
    puts 'assigning promotions for division ' + division.name

    participants = division.league_participants.order(
      score: :desc, mov: :desc, id: :desc
    )
    next if participants.blank?

    participants.first.promote
    participants.second.promote

    # Coruscant demotes 6 players
    if division.tier == 1
      6.times do |i|
        participants[-1 - i].demote
      end
    else
      participants[-1].demote
      participants[-2].demote
    end
  end
end
