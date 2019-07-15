class User < ApplicationRecord
  has_many :identities
  has_many :league_participants
  has_one :season_seven_survey
  has_many :league_signups

  def self.find_with_omniauth(auth)
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  # TODO: handle future seasons better
  def current_league_participant
    LeagueParticipant
      .joins(:season)
      .where('user_id = ? AND seasons.season_number = ?', id, 8)
      .order(:created_at)
      .first
  end

  def self.create_with_omniauth(auth)
    user = User.create(
      name: auth&.info&.name,
      email: auth&.info&.email,
      display_name: auth&.info&.nickname
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
