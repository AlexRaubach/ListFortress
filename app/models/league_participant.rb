class LeagueParticipant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :division, optional: true
  has_many :wins, as: :winner, class_name: 'Match'

  def matches
    Match.where(
      '(player1_id = :id AND player1_type = :type) OR (player2_id = :id AND player2_type = :type)',
      id: id, type: 'LeagueParticipant'
    )
  end

  def name
    return user.display_name if user

    return list_juggler_name if list_juggler_name

    id.to_s
  end
end
