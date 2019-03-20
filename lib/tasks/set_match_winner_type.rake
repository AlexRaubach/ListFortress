# Matches were made polymorphic after some work on them was done and many were saved
# before I noticed that the type wasn't also being set. This task is to fix that issue
desc 'Fix Matches that are missing a playerX_type or winner_type'
task set_match_winner_type: :environment do
  league_matches = Match.where(
    'league_match is true and winner_type is null and winner_id is not null'
  )
  puts "Fixing #{league_matches.size} league matches"
  league_matches.each do |match|
    match.winner_type = 'LeagueParticipant'
    match.save
  end

  normal_matches = Match.where('league_match is null and player1_type is null')
  puts "Fixing #{normal_matches.size} normal matches"

  normal_matches.each do |match|
    match.player1_type = 'Participant'
    match.player2_type = 'Participant'
    match.winner_type = 'Participant' if match.winner_id.present?

    match.save
  end

end