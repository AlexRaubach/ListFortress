desc 'Reset Participant counter cache'
task reset_participants: :environment do
  Tournament.find_each { |tournament| Tournament.reset_counters(tournament.id, :participants) }
end