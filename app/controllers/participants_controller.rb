class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update]
  protect_from_forgery unless: -> { request.format.json? }

  # GET /participants
  # GET /participants.json
  def index
    # Paginated: the full table is far too large to render or serialise in one response.
    @participants = Participant.order(:id).paginate(page: params[:page], per_page: 100)
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    # belongs_to :tournament, touch: true keeps the tournament's updated_at current
    @participant = Participant.new(participant_create_params['participant'])

    respond_to do |format|
      if @participant.save
        format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    respond_to do |format|
      if @participant.update_with_xws(participant_params['participant'])
        format.html { redirect_to @participant.tournament, notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant
      @participant = Participant.find(params[:id])

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
    PARTICIPANT_FIELDS = %i[name swiss_rank top_cut_rank score mov sos dropped list_json squad_url].freeze

    def participant_params
      params.permit(:id, participant: PARTICIPANT_FIELDS)
    end

    # A participant's tournament is set on create only, so updates can't move it to another event.
    def participant_create_params
      params.permit(participant: [:tournament_id, *PARTICIPANT_FIELDS])
    end
end
