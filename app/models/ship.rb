class Ship < ApplicationRecord
  has_many :ships
  belongs_to :factions
end
