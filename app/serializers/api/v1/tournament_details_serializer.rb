class Api::V1::TournamentDetailsSerializer < ActiveModel::Serializer
    #attributes(*Tournament.attribute_names.map(&:to_sym))
    attribute :id
    attribute :name
    attribute :location
    attribute :state
    attribute :country
    attribute :date
    attribute :format_id
    attribute :version_id
    attribute :tournament_type_id
    attribute :created_at
    attribute :updated_at

    has_many :participants, serializer: Api::V1::ParticipantSerializer do
        include_data(true)
        link(:related) {api_v1_participants_path(tournament_id: object.id)}
    end
    has_many :rounds, serializer: Api::V1::RoundSerializer do
        include_data(true)
        link(:related) {api_v1_rounds_path(tournament_id: object.id)}
    end
end