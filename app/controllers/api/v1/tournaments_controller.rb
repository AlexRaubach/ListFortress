class Api::V1::TournamentsController < Api::V1::BaseController
    before_action :load_resource

    def index
        tournaments = @users

        render json: tournaments, each_serializer: Api::V1::TournamentSerializer
    end
    def show
        tournament = Tournament.find(params[:id])

        render json: tournament, include: ['participants', 'rounds', 'rounds.matches'], serializer: Api::V1::TournamentDetailsSerializer
    end

    private
        def load_resource
            validate_params()
              case params[:action].to_sym
            when :index
                @users = Tournament.all.updated_after(params[:updatedafter]) #paginate(Tournament.all)
            when :show
                @user = Tournament.find(params[:id])
            end
        end

    def validate_params
        if params[:updatedafter].present?
            if !validate_updated_after(params[:updatedafter])
              params[:updatedafter] = nil
              return self.api_error(status:404,errors:['invalid updatedafter, requires UTC iso8601 timestamp'])
            end
        end
    end

    def validate_updated_after (updated_after)
        p updated_after
        Time.iso8601(updated_after)      # raises ArgumentError if format invalid
        return true
        rescue ArgumentError => e
            p e
            return false
    end

    def create_params
      normalized_params.permit(
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

    def update_params
      create_params
    end

    def normalized_params
      ActionController::Parameters.new(
         ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      )
    end
end