class Api::V1::LeagueParticipantSerializer < ActiveModel::Serializer
    attributes :id, :division_id, :created_at, :updated_at, :list_juggler_id, :list_juggler_name, :mov, :score, :losses
end
