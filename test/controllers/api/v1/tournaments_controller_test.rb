require 'test_helper'

module Api
  module V1
    class TournamentsControllerTest < ActionDispatch::IntegrationTest
      test 'index lists every tournament' do
        get api_v1_tournaments_url

        assert_response :success
        names = response.parsed_body.map { |t| t['name'] }
        assert_equal ['Copenhagen Hyperspace Trial', 'Store Championship'], names.sort
        assert_equal %w[country created_at date format_id id location name state tournament_type_id updated_at version_id],
                     response.parsed_body.first.keys.sort
      end

      test 'index filters by updatedafter' do
        tournaments(:hyperspace).touch

        get api_v1_tournaments_url, params: { updatedafter: 1.minute.ago.utc.iso8601 }

        assert_response :success
        assert_equal ['Copenhagen Hyperspace Trial'], response.parsed_body.map { |t| t['name'] }
      end

      test 'index rejects a malformed updatedafter' do
        get api_v1_tournaments_url, params: { updatedafter: 'last tuesday' }

        assert_response :not_found
        assert_match(/iso8601/, response.parsed_body['errors'].first['detail'])
      end

      test 'show includes participants, rounds and matches' do
        get api_v1_tournament_url(tournaments(:store_champ))

        assert_response :success
        body = response.parsed_body
        assert_equal 'Store Championship', body['name']
        assert_equal %w[Alice Bob], body['participants'].map { |p| p['name'] }.sort
        match = body.dig('rounds', 0, 'matches', 0)
        assert_equal [200, 50], [match['player1_points'], match['player2_points']]
        assert_equal participants(:alice).id, match['winner_id']
      end

      test 'show loads rounds and matches without a query per round' do
        tournament = tournaments(:store_champ)
        3.times do |i|
          round = Round.create!(tournament: tournament, roundtype_id: Roundtype::SWISS_ID, round_number: i + 2)
          Match.create!(round: round)
        end

        # tournament, participants, rounds, matches
        assert_queries_count(4) { get api_v1_tournament_url(tournament) }
        assert_equal 4, response.parsed_body['rounds'].size
      end

      test 'show returns a json 404 for an unknown tournament' do
        get api_v1_tournament_url(id: 0)

        assert_response :not_found
        assert_equal 'Not found', response.parsed_body['errors'].first['title']
      end
    end
  end
end
