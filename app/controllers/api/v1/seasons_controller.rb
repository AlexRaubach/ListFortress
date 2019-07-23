class Api::V1::SeasonsController < ActionController::API
  def index
    seasons = Season.all.order(:season_number)

    render json: seasons, each_serializer: Api::V1::SeasonSerializer
  end

  def show
    season = Season.find(params[:id])

    render json: season, serializer: Api::V1::SeasonDetailsSerializer
  end
end
