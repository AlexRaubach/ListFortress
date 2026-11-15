require 'test_helper'

# Covers the league models: Season, Division, LeagueParticipant, Match pairing and User.
class LeagueTest < ActiveSupport::TestCase
  test 'season numbers are unique' do
    assert_not Season.new(season_number: 12).valid?
  end

  test 'joining a division schedules a match against every existing member' do
    division = divisions(:current_1a)
    newcomer = LeagueParticipant.create!(user: users(:admin))

    assert_difference -> { Match.where(league_match: true).count }, 2 do
      division.add_participant(newcomer)
    end

    assert_equal division, newcomer.reload.division
    opponents = newcomer.matches.map(&:player2)
    assert_equal league_participants(:player_current, :legacy).sort_by(&:id), opponents.sort_by(&:id)
  end

  test 'Season.add_participant places the user in the matching division' do
    assert_difference -> { divisions(:current_1a).league_participants.count }, 1 do
      Season.add_participant(12, users(:admin).id, 1, 'A')
    end
  end

  test 'duplicate_exists? matches pairings in either order' do
    a = league_participants(:player_current)
    b = league_participants(:legacy)
    Match.create!(player1: a, player2: b, league_match: true)

    assert Match.duplicate_exists?(a.id, b.id, true)
    assert Match.duplicate_exists?(b.id, a.id, true)
    assert_not Match.duplicate_exists?(a.id, b.id, false)
  end

  test 'league participant names prefer the user, then the list juggler name, then the id' do
    assert_equal 'player', league_participants(:player_current).name
    assert_equal 'Legacy Pilot', league_participants(:legacy).name

    anonymous = LeagueParticipant.create!
    assert_equal anonymous.id.to_s, anonymous.name
  end

  test 'promote and demote set the promotion flag' do
    participant = league_participants(:player_current)

    participant.promote
    assert_equal 1, participant.reload.promotion
    participant.demote
    assert_equal(-1, participant.reload.promotion)
  end

  test 'current_league_participant comes from the current season' do
    assert_equal league_participants(:player_current), users(:player).current_league_participant
    assert_nil users(:admin).current_league_participant
  end

  test 'season csv lists every participant by division' do
    rows = CSV.parse(seasons(:previous).to_csv, headers: true)

    assert_equal 1, rows.size
    assert_equal [users(:player).id.to_s, 'player', 'Division 1A', '1', 'A'],
                 rows.first.fields('user_id', 'name', 'division_name', 'division_tier', 'division_letter')
  end

  test 'slack sign ups are league eligible' do
    auth = OmniAuth::AuthHash.new(
      provider: 'slack', uid: 'U123',
      info: { name: 'Wedge Antilles', email: 'wedge@example.com', nickname: 'wedge', image: 'avatar.png', user_id: 'U123' }
    )

    user = User.create_with_omniauth(auth)

    assert user.persisted?
    assert_equal %w[wedge U123 avatar.png], [user.display_name, user.slack_id, user.slack_avatar]
    assert user.league_eligible
  end
end
