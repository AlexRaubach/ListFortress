class LeagueController < ApplicationController
  def index
  end

  def interdivisional
    if current_user&.league_participants&.first
      @participants = LeagueParticipant
                      .joins(:division, :season)
                      .includes(:user)
                      .where(
                        'divisions.season_id = ?
                        AND divisions.tier = ?
                        AND divisions.id != ?',
                        current_user.league_participants.first.season.id,
                        current_user.league_participants.first.division.tier,
                        current_user.league_participants.first.division.id
                      )
    end
  end

  def create_interdivisional
    match = Match.new(
                      leage_match: true,
                      player1: current_user,
                      player2: LeagueParticipant.find(params['player2_id'])
                    )
    respond_to do |format|
      if match.save
        format.html { redirect_to '/league', notice: 'Interdivisional Match was successfully created.' }
      else
        format.html { render :interdivisional, notice: 'Match could not be saved' }
      end
    end
  end

end