class SeasonSevenSurveysController < ApplicationController
  before_action :set_season_seven_survey, only: [:show, :edit, :update, :destroy]

  # GET /season_seven_surveys
  # GET /season_seven_surveys.json
  def index
    @season_seven_surveys = SeasonSevenSurvey.all.includes(:user)
  end

=begin
  # GET /season_seven_surveys/1
  # GET /season_seven_surveys/1.json
  def show
  end

  # GET /season_seven_surveys/new
  def new
    @season_seven_survey = SeasonSevenSurvey.new
  end

  # GET /season_seven_surveys/1/edit
  def edit
  end

  # POST /season_seven_surveys
  # POST /season_seven_surveys.json
  def create
    params = season_seven_survey_params['season_seven_survey']
    user = current_user
    user.name = params['full_name'] if params['full_name']
    user.display_name = params['display_name'] if params['display_name']
    user.save
    @season_seven_survey = SeasonSevenSurvey.new(params)
    @season_seven_survey.user_id = user.id

    respond_to do |format|
      if @season_seven_survey.save
        format.html { redirect_to '/league', notice: 'Season seven survey was successfully created.' }
        format.json { render :show, status: :created, location: @season_seven_survey }
      else
        format.html { render :new }
        format.json { render json: @season_seven_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /season_seven_surveys/1
  # PATCH/PUT /season_seven_surveys/1.json
  def update
    params = season_seven_survey_params['season_seven_survey']
    user = current_user
    return false unless user == @season_seven_survey.user || user.admin

    user.name = params['full_name'] if params['full_name']
    user.display_name = params['display_name'] if params['display_name']
    user.save

    respond_to do |format|
      if @season_seven_survey.update(params)
        format.html { redirect_to '/league', notice: 'Season seven survey was successfully created.' }
        format.json { render :show, status: :ok, location: @season_seven_survey }
      else
        format.html { render :edit }
        format.json { render json: @season_seven_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /season_seven_surveys/1
  # DELETE /season_seven_surveys/1.json
  def destroy
    user = current_user
    return false unless user == @season_seven_survey.user || user.admin

    @season_seven_survey.destroy
    respond_to do |format|
      format.html { redirect_to '/league', notice: 'Season seven survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
=end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_season_seven_survey
    @season_seven_survey = SeasonSevenSurvey.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def season_seven_survey_params
    params.permit(season_seven_survey:
      [:full_name, :display_name, :time_zone,
      :time, :s1_id, :s2_id, :s3_id, :s4_id, :s5_id, :s6_id
    ])
  end
end
