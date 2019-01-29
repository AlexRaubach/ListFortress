class Api::V1::TournamentSerializer < ActiveModel::Serializer
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
end