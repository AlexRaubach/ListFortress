desc 'Creates a csv with all winners from a season'
task export_users: :environment do
  file = "#{Rails.root}/tmp/users.csv"
  CSV.open(file, 'w') do |csv|
    User.all.each do |user|
      csv << [user.id, user.name, user.display_name, user.email]
    end
  end
end
