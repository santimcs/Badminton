json.extract! event, :id, :abbr, :name, :no_of_players, :sequence, :created_at, :updated_at
json.url event_url(event, format: :json)