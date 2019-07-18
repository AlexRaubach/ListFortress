class LeagueController < ApplicationController
  def index
  end

  def interdivisional
    if Season::INTERDIVISIONAL_ALLOWED && current_user&.current_league_participant
      @participants = LeagueParticipant
                      .joins(:division, :season)
                      .includes(:user)
                      .where(
                        'divisions.season_id = ?
                        AND divisions.tier = ?
                        AND divisions.id != ?',
                        current_user.current_league_participant.season.id,
                        current_user.current_league_participant.division.tier,
                        current_user.current_league_participant.division.id
                      )
                      .order('users.display_name asc')
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

    respond_to do |format|
      # check for a current user to prevent saving a match with only one user due to log out after loading ID page
      if current_user&.current_league_participant&.present? && match.save
        format.html { redirect_to match.player1, notice: 'Interdivisional Match was successfully created.' }
      else
        format.html { render :interdivisional, notice: 'Match could not be saved' }
      end
    end
  end
end
