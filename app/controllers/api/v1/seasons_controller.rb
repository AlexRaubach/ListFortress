class Api::V1::SeasonsController < ActionController::API
  def index
    seasons = Season.all

    render json: seasons, each_serializer: Api::V1::SeasonSerializer
  end

  def show
    season = Season.find(params[:id])

    render json: season, each_serializer: Api::V1::SeasonSerializer
  end
end
