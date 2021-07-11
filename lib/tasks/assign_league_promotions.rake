desc 'Assign all promotions and demotions'
task assign_league_promotions: :environment do
  season = Season.find_by(season_number: 11)
  # the number of players to promote per tier.
  # First item nil since divisions start at tier 1
  promote = [nil, 0, 3, 2, 2]
  demote = [nil, 6, 3, 2, 0] # same with demotions

  season.divisions.each do |division|
    puts 'assigning promotions for division ' + division.name

    participants = division.league_participants.order(
      score: :desc, mov: :desc, id: :desc
    )
    next if participants.blank?

    promote_number = promote[division.tier]
    demote_number = demote[division.tier]

    promote_number.times do |i|
      participants[i].promote
    end

    demote_number.times do |i|
      participants[-1 - i].demote
    end
  end
end
