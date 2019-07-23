desc 'Creates a csv with all pilot inits'
task generate_pilot_skill_csv: :environment do
  file = "#{Rails.root}/tmp/pilots.csv"

  CSV.open(file, 'w') do |csv|
    Pilot.all.each do |pilot|
      csv << [pilot.xws, pilot.initiative]
    end
  end
end
