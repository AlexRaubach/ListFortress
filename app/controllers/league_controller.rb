class LeagueController < ApplicationController
  def index
  end

  def interdivisional
    tier = current_user&.current_league_participant&.division&.tier
    if Season::INTERDIVISIONAL_ALLOWED && tier
      if tier < 4
        @participants = LeagueParticipant
                        .joins(:division, :season)
                        .includes(:user)
                        .where(
                          'divisions.season_id = ?
                          AND divisions.tier = ?
                          AND divisions.id != ?',
                          current_user.current_league_participant.season.id,
                          tier,
                          current_user.current_league_participant.division.id
                        )
                        .order('users.display_name asc')
      else
        @participants = LeagueParticipant
                        .joins(:division, :season)
                        .includes(:user)
                        .where(
                          'divisions.season_id = ?
                          AND (divisions.tier = ? OR divisions.tier = ?)
                          AND divisions.id != ?',
                          current_user.current_league_participant.season.id,
                          4,
                          5,
                          current_user.current_league_participant.division.id
                        )
                        .order('users.display_name asc')
      end
    elsif Season::INTERDIVISIONAL_ALLOWED
      redirect_to league_path, notice: 'You must be signed in and registered for the league to access that page'
    else
      redirect_to league_path, alert: 'Interdivisional play is currently disabled'
    end
  end

  def create_interdivisional
    match = Match.new(
      league_match: true,
      player1: current_user&.current_league_participant,
      player2: LeagueParticipant.find(params['player2_id'])
    )

    # check for a current user to prevent saving a match with only one user due to log out after loading ID page
    if current_user&.current_league_participant&.blank?
      redirect_to interdivisional_path, alert: 'You must be signed in to create a match'
    elsif match.player2_id.nil?
      redirect_to interdivisional_path, alert: 'Invalid Player 2. Try again'
    elsif Match.duplicate_exists?(match.player1_id, match.player2_id, true)
      redirect_to interdivisional_path, alert: 'A match already exists between these two players'
    elsif match.save
      redirect_to league_participant_path(current_user.current_league_participant),
                  notice: 'Interdivisional Match was successfully created.'
    else
      redirect_to interdivisional_path, alert: 'Match could not be saved'
    end
  end
end
