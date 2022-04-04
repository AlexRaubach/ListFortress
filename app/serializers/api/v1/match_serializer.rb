class Api::V1::MatchSerializer < ActiveModel::Serializer
  # attributes(*Match.attribute_names.map(&:to_sym))
  attribute :id
  attribute :player1_id
  attribute :player1_points
  attribute :player2_id
  attribute :player2_points
  attribute :result
  attribute :winner_id
  attribute :rounds_played
  attribute :went_to_time
end
