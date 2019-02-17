desc 'Creates a csv with all the data needed to seed S8'
task generate_season_8_seeding_data: :environment do
  file = "#{Rails.root}/season8.csv"
  CSV.open(file, 'w') do |csv|
    csv << ['id', 'name', 'time_zone_offset', 'desired_start_time', 'adjusted_start_time', 'provisional_tier']

    SeasonSevenSurvey.all.each do |record|
      csv_data = []
      csv_data << record.user_id
      csv_data << record.display_name
      offset = (ActiveSupport::TimeZone.new(record.time_zone).utc_offset / 3600)
      csv_data << offset.to_s
      csv_data << record.time
      csv_data << (record.time + offset) % 24

      participant_ids = [record.s1_id, record.s2_id, record.s3_id, record.s4_id, record.s5_id, record.s6_id].compact
      provisional_ranking = 5
      if participant_ids.present?
        last_id = participant_ids[-1]
        participant = LeagueParticipant.find(last_id)
        provisional_ranking = participant.division.tier
        provisional_ranking -= participant.promotion if participant.promotion
      end
      csv_data << provisional_ranking

      csv << csv_data
    end
  end
end
