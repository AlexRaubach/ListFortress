class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params[:id])
    @matches = @league_participant.matches.with_attached_log_file
    @authorized = @league_participant.division.season.current_season? &&
    (current_user&.admin ||
    current_user&.id == @league_participant.user_id)
  end

  private

  def match_params
    params.permit(:id)
  end
end
