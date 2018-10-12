class Ship < ApplicationRecord
  has_many :pilots
  belongs_to :factions, optional: true
end
