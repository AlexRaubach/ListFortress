class SeasonSevenSurvey < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
  attr_accessor :time_zone, :time
end
