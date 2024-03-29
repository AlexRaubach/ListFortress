class Api::V1::ParticipantSerializer < ActiveModel::Serializer
  # attributes(*Participant.attribute_names.map(&:to_sym))

  attribute :id
  attribute :name
  attribute :tournament_id
  attribute :score
  attribute :swiss_rank
  attribute :top_cut_rank
  attribute :mov
  attribute :sos
  attribute :dropped
  attribute :list_points
  attribute :list_json
  attribute :event_points
  attribute :mission_points
end
