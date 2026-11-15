require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test 'swiss rounds sort before top cut rounds' do
    tournament = tournaments(:store_champ)
    rounds = [
      Round.new(tournament: tournament, roundtype: roundtypes(:elimination), round_number: 1),
      Round.new(tournament: tournament, roundtype: roundtypes(:swiss), round_number: 2),
      Round.new(tournament: tournament, roundtype: roundtypes(:elimination), round_number: 2),
      Round.new(tournament: tournament, roundtype: roundtypes(:swiss), round_number: 1)
    ]

    sorted = rounds.sort_by(&:sort_value).map { |r| [r.roundtype.name, r.round_number] }

    assert_equal [['swiss', 1], ['swiss', 2], ['elimination', 2], ['elimination', 1]], sorted
  end

  test 'create_matches adds match_number empty matches' do
    round = Round.create!(tournament: tournaments(:store_champ), roundtype: roundtypes(:swiss), round_number: 2)
    round.match_number = '3'

    assert_difference -> { round.matches.count }, 3 do
      round.create_matches
    end
  end

  test 'create_matches does nothing without match_number' do
    round = rounds(:store_champ_swiss_1)

    assert_no_difference -> { Match.count } do
      round.create_matches
    end
  end

  test 'update_from_json adds empty matches up to match_number' do
    round = rounds(:store_champ_swiss_1)

    assert round.update_from_json('match_number' => '3', 'round_number' => 2)

    assert_equal 3, round.matches.count
    assert_equal 2, round.reload.round_number
  end
end
