class Tournament < ApplicationRecord
  has_many :participants
  belongs_to :format
  belongs_to :version, optional: true
  belongs_to :tournament_type
  attr_accessor :participant_number

  def create_empty_squads
    return if participant_number.to_i.zero?
    participant_number.to_i.times do |i|
      Participant.new(swiss_rank: i + 1, tournament_id: id).save
    end
  end

  def self.to_csv
    header = %w{tournamentName type format date playerName squad score mov sos swiss_rank top_cut_rank}
    CSV.generate(headers:true) do |csv| 
      csv << header

      all.each do |tournament|
        tournament_name = tournament.name
        type = TournamentType.find(tournament.tournament_type_id).name
        format = Format.find(tournament.format_id).name
        date = tournament.date

        tournament.participants.order(:id).each do |participant|
          player_name = participant.name
          squad = participant.list_json
          score = participant.score
          mov = participant.mov
          sos = participant.sos
          swiss_rank = participant.swiss_rank
          top_cut_rank = participant.top_cut_rank

          output = [tournament_name, type, format, date, player_name, squad, score, mov, sos, swiss_rank, top_cut_rank]
          csv << output
        end
        
      end
    end
  end
end
