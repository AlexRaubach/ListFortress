class User < ApplicationRecord
  has_many :identities
  has_many :league_participants

  def self.create_with_omniauth(auth)
    user = User.create(
      name: auth&.info&.name,
      email: auth&.info&.email
    )

    if auth['provider'] == 'slack'
      user.slack_avatar = auth&.info&.image
      user.league_eligible = true
      user.slack_id = auth&.info&.user_id
    end

    user.save
    user
  end
end
