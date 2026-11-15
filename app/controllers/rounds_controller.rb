class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :edit, :update]

  # GET /rounds
  # GET /rounds.json
  def index
    # Paginated: the full table is far too large to render or serialise in one response.
    @rounds = Round.order(:id).paginate(page: params[:page], per_page: 100)
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @matches = @round.matches.order(:id).to_a
    # Tournament matches store bare participant ids (no polymorphic type), so the names
    # are looked up by id in one query rather than through the player associations.
    player_ids = @matches.flat_map { |match| [match.player1_id, match.player2_id, match.winner_id] }.compact.uniq
    @participant_names = Participant.where(id: player_ids).pluck(:id, :name).to_h
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = Round.new(round_create_params['round'])

    respond_to do |format|
      if @round.save
        @round.create_matches
        update_parents(@round)
        format.html { redirect_to @round, notice: 'Round was successfully created.' }
        format.json { render :show, status: :created, location: @round }
      else
        format.html { render :new }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1
  # PATCH/PUT /rounds/1.json
  def update
    respond_to do |format|
      if @round.update_from_json(round_params['round'])
        update_parents(@round)
        format.html { redirect_to @round, notice: 'Round was successfully updated.' }
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.json
  def destroy
    @round.destroy
    respond_to do |format|
      format.html { redirect_to rounds_url, notice: 'round was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def update_parents(round)
      tourney = Tournament.find_by(id:round.tournament_id)
      if tourney.present?
        tourney.touch
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = Round.find(params[:id])
						rescue ActiveRecord::RecordNotFound
								render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
						# handle not found error
						rescue ActiveRecord::ActiveRecordError
								render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
						# handle other ActiveRecord errors
						rescue StandardError
								render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    ROUND_FIELDS = %i[roundtype_id round_number matches match_number].freeze

    def round_params
      params.permit(:id, round: ROUND_FIELDS)
    end

    # A round's tournament is set on create only, so updates can't move it to another event.
    def round_create_params
      params.permit(round: [:tournament_id, *ROUND_FIELDS])
    end
end
