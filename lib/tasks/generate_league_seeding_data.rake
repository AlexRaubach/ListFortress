desc 'Creates a csv with all the data needed to seed S9'
task generate_league_seeding_data: :environment do
  file = "#{Rails.root}/public/season10_signup_export.csv"

  CSV.open(file, 'w') do |csv|
    csv << ['user_id', 'user_name', 'time_zone_offset', 'desired_start_time',
            'adjusted_start_time', 'other_info',
            'Tier', 'promotion', 'wins', 'losses', 'mov', 'Season number']

    LeagueSignup.all.where(season_number: 11).each do |signup|
      csv_data = []

      csv_data << signup.user_id
      csv_data << signup.user.display_name
      offset = (ActiveSupport::TimeZone.new(signup.time_zone).utc_offset / 3600)
      csv_data << offset.to_s
      csv_data << signup.time
      csv_data << (signup.time - offset) % 24
      csv_data << signup.other

      lp = signup&.user&.league_participants&.order(id: :desc)&.first
      # this is faster and easier than sorting by season
      if lp
        csv_data << lp.division.tier
        csv_data << lp.promotion
        csv_data << lp.score
        csv_data << lp.losses
        csv_data << lp.mov
        csv_data << lp.season.season_number
      else
        csv_data << 'new player?'
      end

      csv << csv_data
    end
  end
end
