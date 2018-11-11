class User < ApplicationRecord
  has_many :identities
  has_many :league_participants


  def self.create_with_omniauth(info)
    create(name: info['name'])
  end
end
