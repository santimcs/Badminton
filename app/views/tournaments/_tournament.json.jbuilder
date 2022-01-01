json.extract! tournament, :id, :name, :fm_date, :to_date, :country_id, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)