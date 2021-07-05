# frozen_string_literal: true

# The Match class holds an individual game/match. This class is used for both a
# Tournament match where it belongs to Participants and a Round (which belongs to a tournament)
# and the League match where match.league_match will be true and the players+winner will be LeagueParticipants
class Match < ApplicationRecord
  belongs_to :round, optional: true
  belongs_to :player1, polymorphic: true, optional: true
  belongs_to :player2, polymorphic: true, optional: true
  belongs_to :winner, polymorphic: true, optional: true
  has_one_attached :log_file
  attr_accessor :player1_url_temp, :player2_url_temp

  def serializable_hash(options={})
    super({ only: %I[id player1_id player1_points player2_id player2_points result winner_id] }.merge(options || {}))
  end

  def self.duplicate_exists?(first_id, second_id, league_match_bool)
    Match.where("league_match = :league_match_status AND (
                  (player1_id = :firstID and player2_id = :secondID)
                  OR
                  (player1_id = :secondID and player2_id = :firstID)
                )",
                firstID: first_id, secondID: second_id,
                league_match_status: league_match_bool)
         .exists?
  end
end
