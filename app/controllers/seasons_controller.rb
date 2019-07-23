class SeasonsController < ApplicationController
  before_action :set_season, only: :show

  def index
    @seasons = Season.all.order(:season_number)
  end

  def show
    respond_to do |format|
      format.html
      format.csv {
        send_data @season.to_csv,
                  filename: "vassal_league_season_#{@season.season_number}_#{Time.new.strftime('%Y-%m-%d')}.csv"
      }
    end
  end

  private

  def set_season
    @season = Season.includes(:divisions).find_by(season_number: params['season_number'])
  rescue ActiveRecord::RecordNotFound
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  # handle not found error
  rescue ActiveRecord::ActiveRecordError
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  # handle other ActiveRecord errors
  rescue StandardError
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  end
end
