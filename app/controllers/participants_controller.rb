class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update]

  # GET /participants
  # GET /participants.json
  def index
    @participants = Participant.all
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
    @participant = Participant.new(participant_params['participant'])

    respond_to do |format|
      if @participant.save
        update_parents(@participant)
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
        update_parents(@participant)
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
    def update_parents(participant)
      tourney = Tournament.find_by(id:participant.tournament_id)
      if tourney.present?
        tourney.touch
      end
    end
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
    def participant_params
      params.permit(:id, participant:
      [:name, :swiss_rank, :top_cut_rank, :score, :mov, :sos, :dropped, :list_json, :squad_url]
    )
    end
end
