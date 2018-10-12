class Pilot < ApplicationRecord
  belongs_to :ships, optional: true
end
