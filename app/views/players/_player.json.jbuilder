json.extract! player, :id, :first_name, :last_name, :country_id, :image, :created_at, :updated_at
json.url player_url(player, format: :json)