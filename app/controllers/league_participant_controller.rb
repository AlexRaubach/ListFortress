class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params[:id])
    @matches = @league_participant.matches.order(id: :asc)
  end

  private
  def match_params
    params.permit(:id
    )
  end
end
