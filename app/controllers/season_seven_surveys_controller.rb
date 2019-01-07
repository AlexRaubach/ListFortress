class SeasonSevenSurveysController < ApplicationController
  before_action :set_season_seven_survey, only: [:show, :edit, :update, :destroy]

  # GET /season_seven_surveys
  # GET /season_seven_surveys.json
  def index
    @season_seven_surveys = SeasonSevenSurvey.all
  end

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
    @season_seven_survey = SeasonSevenSurvey.new(season_seven_survey_params)

    respond_to do |format|
      if @season_seven_survey.save
        format.html { redirect_to @season_seven_survey, notice: 'Season seven survey was successfully created.' }
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
    respond_to do |format|
      if @season_seven_survey.update(season_seven_survey_params)
        format.html { redirect_to @season_seven_survey, notice: 'Season seven survey was successfully updated.' }
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
    @season_seven_survey.destroy
    respond_to do |format|
      format.html { redirect_to season_seven_surveys_url, notice: 'Season seven survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season_seven_survey
      @season_seven_survey = SeasonSevenSurvey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_seven_survey_params
      params.fetch(:season_seven_survey, {})
    end
end
