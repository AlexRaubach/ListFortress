class Api::V1::SeasonDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :season_number, :created_at, :updated_at

  has_many :divisions, serializer: Api::V1::DivisionSerializer
end
