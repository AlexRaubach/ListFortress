class Match < ApplicationRecord
  belongs_to :round
  has_one :player1, :class_name => 'Participant', :foreign_key => 'player1_id'
  has_one :player2, :class_name => 'Participant', :foreign_key => 'player2_id'
  has_one :winner, :class_name => 'Participant', :foreign_key => 'winner_id'

  def serializable_hash(options={})
    super({:only => [:id,:player1_id,:player1_points,:player2_id,:player2_points,:result, :winner_id]}.merge(options||{}))
  end
end
