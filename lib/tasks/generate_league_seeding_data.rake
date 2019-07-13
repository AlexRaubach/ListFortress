desc 'Creates a csv with all the data needed to seed S8'
task generate_league_seeding_data: :environment do
  file = "#{Rails.root}/public/season8.csv"

  CSV.open(file, 'w') do |csv|
    csv << ['user_id', 'user_name', 'time_zone_offset', 'desired_start_time',
            'adjusted_start_time', 'other_info',
            'S7 Tier', 'promotion', 'S7 wins', 'S7 losses', 'S7 mov']

    LeagueSignup.all.each do |signup|
      csv_data = []

      csv_data << signup.user_id
      csv_data << signup.user.display_name
      offset = (ActiveSupport::TimeZone.new(signup.time_zone).utc_offset / 3600)
      csv_data << offset.to_s
      csv_data << signup.time
      csv_data << (signup.time - offset) % 24
      csv_data << signup.other

      lp = signup&.user&.current_league_participant
      if lp
        csv_data << lp.division.tier
        csv_data << lp.promotion
        csv_data << lp.score
        csv_data << lp.losses
        csv_data << lp.mov
      end

      csv << csv_data
    end
  end
end
