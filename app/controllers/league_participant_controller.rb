class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params[:id])
    @matches = @league_participant.matches.with_attached_log_file
  end

  private

  def match_params
    params.permit(:id)
  end
end
