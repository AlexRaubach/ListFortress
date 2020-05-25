class LeagueSignupsController < ApplicationController
  before_action :set_league_signup, only: [:show, :edit, :update, :destroy]

  # GET /league_signups
  # GET /league_signups.json
  def index
    @league_signups = LeagueSignup.where(season_number: 10).includes(:user)
  end

  # GET /league_signups/1
  # GET /league_signups/1.json
  # def show
  # end

  # GET /league_signups/new
  def new
    redirect_to '/login' if current_user.blank?

    @league_signup = LeagueSignup.new
  end

  # GET /league_signups/1/edit
  # def edit
  # end

  # POST /league_signups
  # POST /league_signups.json
  def create
    return false if current_user.nil?

    current_user.display_name = league_signup_params['display_name']
    current_user.name = league_signup_params['full_name']
    current_user.save

    @league_signup = LeagueSignup.new(league_signup_params.except(:full_name, :display_name))

    @league_signup.season_number = 10
    @league_signup.user = current_user

    respond_to do |format|
      if @league_signup.save
        format.html { redirect_to '/league_signups', notice: 'League signup was successfully created.' }
        format.json { render :show, status: :created, location: @league_signup }
      else
        format.html { render :new }
        format.json { render json: @league_signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /league_signups/1
  # PATCH/PUT /league_signups/1.json
  def update
    return false if current_user.nil?

    current_user.display_name = league_signup_params['display_name']
    current_user.name = league_signup_params['full_name']
    current_user.save

    respond_to do |format|
      if @league_signup.update(league_signup_params.except(:full_name, :display_name))
        format.html { redirect_to '/league_signups', notice: 'League signup was successfully updated.' }
        format.json { render :show, status: :ok, location: @league_signup }
      else
        format.html { render :edit }
        format.json { render json: @league_signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /league_signups/1
  # DELETE /league_signups/1.json
  # def destroy
  #   @league_signup.destroy
  #   respond_to do |format|
  #     format.html { redirect_to league_signups_url, notice: 'League signup was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league_signup
      @league_signup = LeagueSignup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_signup_params
      params.fetch(:league_signup, {}).permit!
    end
end
