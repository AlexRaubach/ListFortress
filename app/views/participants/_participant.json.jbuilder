json.extract! participant, :id, :created_at, :updated_at, :name, :swiss_rank, :top_cut_rank, :score, :mov, :sos, :dropped, :list_json, :squad_url, :mission_points, :event_points
json.url participant_url(participant, format: :json)
