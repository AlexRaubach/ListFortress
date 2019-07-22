class Api::V1::SeasonSerializer < ActiveModel::Serializer
  attributes :id, :name, :season_number, :created_at, :updated_at
end
