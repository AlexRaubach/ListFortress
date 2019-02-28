class Match < ApplicationRecord
  belongs_to :round, optional: true
  belongs_to :player1, polymorphic: true, optional: true
  belongs_to :player2, polymorphic: true, optional: true
  belongs_to :winner, polymorphic: true, optional: true
  attr_accessor :player1_url_temp, :player2_url_temp

  def serializable_hash(options={})
    super({only: [:id, :player1_id, :player1_points, :player2_id, :player2_points, :result, :winner_id]}.merge(options||{}))
  end
end
