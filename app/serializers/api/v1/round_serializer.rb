class Api::V1::RoundSerializer < ActiveModel::Serializer
    #attributes(*Round.attribute_names.map(&:to_sym))
    attribute :id
    attribute :tournament_id
    attribute :roundtype_id
    attribute :round_number

    has_many :matches, serializer: Api::V1::MatchSerializer do
        include_data(true)
        link(:related) {api_v1_matches_path(round_id: object.id)}
    end
    #has_many :rounds, serializer: Api::V1::RoundSerializer do
    #    include_data(true)
    #    link(:related) {api_v1_rounds_path(tournament_id: object.id)}
    #end
end