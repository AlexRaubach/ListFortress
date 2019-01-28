class Division < ApplicationRecord
  belongs_to :season
  has_many :leagueparticipants
end
