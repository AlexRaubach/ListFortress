desc 'Fix BCP Matches that have the wrong participants'
task redo_bcp_matches: :environment do
  # There was a bug in the BCP importer that matched Participants by just name instead of name and tournament
  # This rake task is designed to go back and fix those matches
  affected_tournaments = [495,505,510,568,583,648,690,717].freeze

  def fix_match(match, tournament_id)


  end


  affected_tournaments.each do |tournament_id|
    Tournament.find(tournament_id).rounds.each do |round|
      round.matches.each do |match|
        fix_match(match, tournament_id)
      end
    end
  end
end
