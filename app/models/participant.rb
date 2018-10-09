class Participant < ApplicationRecord
  belongs_to :tournament
  attr_accessor :squad_url
end
