desc 'Update all League Participant Scores and MoV for the current season'
task calculate_league_scores: :environment do
  Season.where(active: true).each do |current_season|
    current_season.divisions.each do |division|
      # Coruscant players should play 2 additional games
      maximum_matches = division.tier == 1 ? 10 : 8
      puts 'Calculating scores for division ' + division.name

      division.league_participants.each do |player|
        mov = 0
        score = 0

        matches = Match
                  .order(:updated_at)
                  .limit(maximum_matches)
                  .where(
                    'winner_id is not null and
                    ((player1_id = :id AND player1_type = :type)
                    OR (player2_id = :id AND player2_type = :type))',
                    id: player.id, type: 'LeagueParticipant'
                  )

        matches.each do |match|
          score += 1 if match.winner_id == player.id

          next if match.player1_points.nil? || match.player2_points.nil?

          player_points_killed = 0
          opponent_points_killed = 0

          if match.player1 == player
            player_points_killed = match.player1_points
            opponent_points_killed = match.player2_points
          else
            player_points_killed = match.player2_points
            opponent_points_killed = match.player1_points
          end
          mov += 200 + player_points_killed - opponent_points_killed
        end

        player.score = score
        player.losses = matches.size - score
        player.mov = mov
        player.save
      end
    end
  end
end
