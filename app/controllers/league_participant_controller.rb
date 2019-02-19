class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params)
  end

  private
  def match_params
    params.permit(:id
    )
  end
end
