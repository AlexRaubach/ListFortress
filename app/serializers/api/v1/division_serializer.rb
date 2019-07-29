class Api::V1::DivisionSerializer < ActiveModel::Serializer
  attributes :id, :name, :season_id, :tier, :letter, :created_at, :updated_at

  # has_many :league_participants, serializer: Api::V1::LeagueParticipantSerializer
end
