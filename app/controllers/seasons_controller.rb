class SeasonsController < ApplicationController
  before_action :set_season, only: :show

  def index
    @seasons = Season.all
  end

  def show
  end

  private

  def set_season
    @season = Season.includes(:divisions).find(params['id'])
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
