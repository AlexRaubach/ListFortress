class DivisionsController < ApplicationController

  def show
    @division = Division.find(params['id'])
    @players = @division.league_participants.order(score: :desc, mov: :desc, id: :asc)
  end

end