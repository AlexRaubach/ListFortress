class LeagueParticipantController < ApplicationController
  def show
    @league_participant = LeagueParticipant.find(params[:id])
    @matches = @league_participant.matches
                                  .includes({ player1: :user }, { player2: :user })
                                  .with_attached_log_file
                                  .order(winner_id: :asc, id: :asc)

    @authorized = @league_participant&.division&.season&.active || current_user&.admin
  end

  private

  def match_params
    params.permit(:id)
  end
end
