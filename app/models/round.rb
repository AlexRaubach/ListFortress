class Round < ApplicationRecord
  belongs_to :tournament
  belongs_to :roundtype
  has_many :matches, dependent: :destroy
  attr_accessor :match_number

  def create_matches
    return if :match_number.zero?

    :match_number.times do |i|
      Match.new(round_id: id).save
    end
  end

  def sort_value
    # if swiss sort asc
    if roundtype_id == 1
      round_number
    # If top cut sort desc and make them come after the swiss rounds
    else
      100 - round_number
    end
  end

  def serializable_hash(options={})
    super({:only => [:id,:tournament_id,:roundtype_id,:round_number],:include => [:matches]}.merge(options||{}))
  end

  def update_from_json(round_data)
    if round_data['match_number'].present?
      matchnum = round_data['match_number'].to_i
      matchsize = matches.present? ? matches.size : 0
      if matchnum > matchsize
        (matchnum-matchsize).times do |i|
          Match.new(round_id:id).save
        end
      end
    end

    update(round_data)
  end
end
