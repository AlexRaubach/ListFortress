class DivisionsController < ApplicationController
  def show
    @division = Division.includes(:season).find(params['id'])
    @players = @division.league_participants.includes(:user).order(score: :desc, mov: :desc, id: :asc)
  end
end
