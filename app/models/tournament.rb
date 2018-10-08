class Tournament < ApplicationRecord
  has_many :participants
  has_one :format
  has_one :version
  attr_accessor :participant_number

  def create_empty_squads
    return if participant_number.to_i.zero?
    participant_number.to_i.times do |i|
      Participant.new(overall_rank: i + 1, tournament_id: id).save
    end
  end
end
