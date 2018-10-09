class Participant < ApplicationRecord
  belongs_to :tournament
  attr_accessor :squad_url

  def self.get_xws_from_yasb2(query_string)
    url = 'https://yasb2-xws.herokuapp.com/' + query_string
    response = HTTParty.get(url)
    JSON(response.parsed_response)
  end
end
