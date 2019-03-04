class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params[:id])
    @matches = Match.where(
      '(player1_id = :id AND player1_type = :type) OR (player2_id = :id AND player2_type = :type)',
      id: @league_participant&.id, type: 'LeagueParticipant'
    )
  end

  private
  def match_params
    params.permit(:id
    )
  end
end
