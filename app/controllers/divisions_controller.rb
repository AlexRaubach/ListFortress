class DivisionsController < ApplicationController

  def show
    @division = Division.find(params['id'])
  end

end