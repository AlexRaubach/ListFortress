class SeasonsController < ApplicationController
  def index
    @seasons = Season.all
  end

  def show
    @season
  end
end
