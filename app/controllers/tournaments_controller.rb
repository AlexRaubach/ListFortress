class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]
  has_scope :max_participants, :min_participants, :country, :name_search,
            :format_id, :tournament_type_id, :played_before, :played_after,
            :sort_order
  # before_action :authenticate, only: [:destroy]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = apply_scopes(Tournament).all
                                           .includes(:tournament_type, :format)
                                           .order(date: :desc, id: :desc)
                                           .paginate(page: params[:page], per_page: 25)
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @participants = @tournament.participants.order(Arel.sql('
      swiss_rank = 0, swiss_rank asc, score desc, mov desc, id asc
      '
    ))

    @rounds = @tournament.rounds.sort_by(&:sort_value)
    respond_to do |format|
      format.html
      format.csv { send_data Tournament.where(id: params[:id]).to_csv, filename: "listfortress-#{@tournament.id}.csv"}
    end
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params['tournament'])

    if @tournament.save
      valid_tounament = @tournament.create_squads
    else
      valid_tounament = false
    end

    respond_to do |format|
      if valid_tounament && @tournament.participants.count > 1
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        @tournament.destroy
        flash.now[:alert] = 'Something isn\'t right about this submission. Consider rechecking any urls'
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update_from_json(tournament_params['tournament'])
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    if current_user&.admin
      @tournament.destroy
      respond_to do |format|
        format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # RSS feed
  def feed
    @tournaments = Tournament.last(30)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.includes(rounds: :matches).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  # handle not found error
  rescue ActiveRecord::ActiveRecordError
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  # handle other ActiveRecord errors
  rescue StandardError
    render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tournament_params
    params.permit(
      :name, tournament:
      [
        :id, :name, :participant_number,
        :type, :format_id, :country,
        :state, :organizer_id, :location,
        :patch_id, :tournament_type_id, :date,
        :tabletop_url, :cryodex_json, :round_number
      ]
    )
  end
end
