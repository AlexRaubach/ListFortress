desc 'Fix BCP Matches that have the wrong participants'
task redo_bcp_matches: :environment do
  # There was a bug in the BCP importer that matched Participants 
  # by just name instead of name and tournament
  # This rake task is designed to go back and fix those matches
  affected_tournaments = [495, 505, 510, 568, 583, 648, 690, 717].freeze

  def fix_match(match, tournament_id)
    player1_name = match&.player1&.name
    player2_name = match&.player2&.name
    winner_name = match&.winner&.name

    match.player1 = Participant.find_by(name: player1_name, tournament_id: tournament_id)
    match.player2 = Participant.find_by(name: player2_name, tournament_id: tournament_id)
    match.winner =  Participant.find_by(name: winner_name, tournament_id: tournament_id)

    match.save
  end

  affected_tournaments.each do |tournament_id|
    Tournament.find(tournament_id).rounds.each do |round|
      round.matches.each do |match|
        fix_match(match, tournament_id)
      end
    end
  end
end
