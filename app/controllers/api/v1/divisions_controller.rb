class Api::V1::DivisionsController < ActionController::API
  def index
    divisions = Division.all.order(:id)

    render json: divisions, each_serializer: Api::V1::DivisionSerializer
  end

  def show
    division = Division.find(params[:id])

    render json: division, serializer: Api::V1::DivisionDetailsSerializer
  end
end
