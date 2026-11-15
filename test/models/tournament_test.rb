require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  def new_tournament(**attrs)
    Tournament.create!(
      { name: 'New Event', date: Date.new(2025, 1, 1),
        format: formats(:second_edition), tournament_type: tournament_types(:store_event) }.merge(attrs)
    )
  end

  def match_between(round, p1_name, p2_name)
    round.matches.joins('JOIN participants p1 ON p1.id = matches.player1_id')
         .joins('JOIN participants p2 ON p2.id = matches.player2_id')
         .find_by('p1.name = ? AND p2.name = ?', p1_name, p2_name)
  end

  test 'requires a date' do
    tournament = Tournament.new(format: formats(:second_edition), tournament_type: tournament_types(:store_event))

    assert_not tournament.valid?
    assert_includes tournament.errors[:date], "can't be blank"
  end

  # --- scopes -------------------------------------------------------------

  test 'participant count scopes' do
    assert_equal [tournaments(:hyperspace)], Tournament.min_participants(3).to_a
    assert_equal [tournaments(:store_champ)], Tournament.max_participants(2).to_a
  end

  test 'name_search is case insensitive' do
    assert_equal [tournaments(:hyperspace)], Tournament.name_search('COPENHAGEN').to_a
  end

  test 'date scopes are inclusive' do
    assert_equal [tournaments(:store_champ)], Tournament.played_after('2024-05-01').to_a
    assert_equal [tournaments(:hyperspace)], Tournament.played_before('2023-03-11').to_a
  end

  test 'sort_order uses known keys and falls back to newest first' do
    assert_equal tournaments(:hyperspace, :store_champ), Tournament.sort_order('date_asc').to_a
    assert_equal tournaments(:hyperspace, :store_champ), Tournament.sort_order('size_desc').to_a
    assert_equal tournaments(:store_champ, :hyperspace), Tournament.sort_order('drop table').to_a
  end

  test 'updated_after ignores blank values' do
    assert_equal Tournament.count, Tournament.updated_after(nil).count
    assert_equal 0, Tournament.updated_after(1.day.from_now).count
  end

  # --- create_squads ------------------------------------------------------

  test 'create_squads builds empty participants from a player count' do
    tournament = new_tournament
    tournament.participant_number = '4'

    assert tournament.create_squads
    assert_equal [1, 2, 3, 4], tournament.participants.order(:swiss_rank).pluck(:swiss_rank)
  end

  test 'create_squads fails with no source of participants' do
    assert_not new_tournament.create_squads
  end

  test 'create_squads imports players, rounds and matches from cryodex json' do
    tournament = new_tournament
    tournament.cryodex_json = fixture_file('listjuggler_tournament.json')

    assert tournament.create_squads

    han = tournament.participants.find_by!(name: 'Han')
    assert_equal [10, 300, 1, 1], [han.score, han.mov, han.swiss_rank, han.top_cut_rank]
    assert_equal BigDecimal('1.5'), han.sos
    assert han.list_json.present?
    assert_nil tournament.participants.find_by!(name: 'Lando').top_cut_rank

    swiss = tournament.rounds.find_by!(roundtype: roundtypes(:swiss))
    assert_equal 'Assault at the Satellite Array', swiss.scenario
    assert_equal 2, swiss.matches.count
    assert_equal 1, tournament.rounds.where(roundtype: roundtypes(:elimination)).count
  end

  test 'cryodex json also works without the outer tournament key' do
    tournament = new_tournament
    tournament.cryodex_json = JSON.parse(fixture_file('listjuggler_tournament.json'))['tournament'].to_json

    assert tournament.create_squads
    assert_equal 3, tournament.participants.count
    assert_equal 2, tournament.rounds.count
  end

  test 'cryodex json without players is rejected' do
    tournament = new_tournament
    tournament.cryodex_json = { tournament: { players: [] } }.to_json

    assert_not tournament.create_squads
  end

  test 'imported match winners are inferred from points unless given explicitly' do
    tournament = new_tournament
    tournament.cryodex_json = fixture_file('listjuggler_tournament.json')
    tournament.create_squads

    han = tournament.participants.find_by!(name: 'Han')
    swiss = tournament.rounds.find_by!(roundtype: roundtypes(:swiss))
    # Imported matches only store ids (no polymorphic *_type), so compare ids rather than associations.
    assert_equal han.id, match_between(swiss, 'Han', 'Leia').winner_id
    assert_nil match_between(swiss, 'Lando', 'Leia').winner_id

    # An explicit winner beats the points comparison.
    top_cut = tournament.rounds.find_by!(roundtype: roundtypes(:elimination))
    assert_equal han.id, match_between(top_cut, 'Han', 'Leia').winner_id
  end

  test 'create_squads pulls the listjuggler export from a tabletop.to url' do
    stub = stub_request(:get, 'https://tabletop.to/my-event/listjuggler')
           .to_return(status: 200, body: fixture_file('listjuggler_tournament.json'))
    tournament = new_tournament
    tournament.tabletop_url = 'tabletop.to/my-event/standings'

    assert tournament.create_squads
    assert_requested stub
    assert_equal %w[Han Lando Leia], tournament.participants.order(:name).pluck(:name)
  end

  test 'create_squads fails on a missing tabletop.to event' do
    stub_request(:get, 'https://tabletop.to/missing/listjuggler').to_return(status: 404)
    tournament = new_tournament
    tournament.tabletop_url = 'https://tabletop.to/missing'

    assert_not tournament.create_squads
    assert_equal 0, tournament.participants.count
  end

  # --- updates & export ---------------------------------------------------

  test 'update_from_json pads participants up to participant_number' do
    tournament = tournaments(:store_champ)

    assert tournament.update_from_json('name' => 'Renamed', 'participant_number' => '4')

    tournament.reload
    assert_equal 'Renamed', tournament.name
    assert_equal 4, tournament.participants.count
  end

  test 'update_from_json pads rounds up to round_number' do
    tournament = tournaments(:store_champ)

    tournament.update_from_json('round_number' => '3')

    rounds = tournament.rounds.order(:round_number)
    assert_equal [1, 2, 3], rounds.map(&:round_number)
    assert rounds.all? { |r| r.roundtype_id == Roundtype::SWISS_ID }
  end

  test 'create_empty_rounds makes numbered swiss rounds' do
    tournament = new_tournament

    tournament.create_empty_rounds(2)

    assert_equal [1, 2], tournament.rounds.where(roundtype_id: Roundtype::SWISS_ID).order(:round_number).pluck(:round_number)
  end

  test 'update_from_json never removes participants' do
    tournament = tournaments(:store_champ)
    tournament.update_from_json('participant_number' => '1')

    assert_equal 2, tournament.participants.count
  end

  test 'to_csv exports one row per participant' do
    rows = CSV.parse(Tournament.where(id: tournaments(:store_champ).id).to_csv, headers: true)

    assert_equal %w[Alice Bob], rows.map { |r| r['playerName'] }
    assert_equal ['Store Championship', 'Store Event', 'Second Edition', '2024-05-01'],
                 rows.first.fields('tournamentName', 'type', 'format', 'date')
  end

  test 'destroying a tournament removes its participants, rounds and matches' do
    tournament = tournaments(:store_champ)

    assert_difference -> { Participant.count } => -2, -> { Round.count } => -1, -> { Match.count } => -1 do
      tournament.destroy
    end
  end
end
