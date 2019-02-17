desc 'Creates a csv with all the data needed to seed S8'
task generate_season_8_seeding_data: :environment do
  file = "#{Rails.root}/season8.csv"
  CSV.open(file, 'w') do |csv|
    csv << ['id', 'name', 'time_zone_offset', 'desired_start_time', 'adjusted_start_time', 'provisional_tier', 'lj_name', 'wins in last season']

    SeasonSevenSurvey.all.each do |record|
      csv_data = []
      csv_data << record.user_id
      csv_data << record.display_name
      offset = (ActiveSupport::TimeZone.new(record.time_zone).utc_offset / 3600)
      csv_data << offset.to_s
      csv_data << record.time
      csv_data << (record.time + offset) % 24

      participant_ids = [record.s1_id, record.s2_id, record.s3_id, record.s4_id, record.s5_id, record.s6_id].compact
      provisional_ranking = 7
      last_name = ''
      last_season_wins = 0
      last_season_matches = 0
      if participant_ids.present?
        last_id = participant_ids[-1]
        participant = LeagueParticipant.find(last_id)
        provisional_ranking = participant.division.tier
        provisional_ranking -= participant.promotion if participant.promotion
        last_name = participant.list_juggler_name
        last_season_wins = Match.where(winner_id: last_id).count
        last_season_matches = Match.where(player1_id: last_id).count + Match.where(player2_id: last_id).count
      end
      csv_data << provisional_ranking
      csv_data << last_name
      csv_data << last_season_wins
      csv_data << last_season_matches - last_season_wins

      csv << csv_data
    end
  end
end
