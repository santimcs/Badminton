class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :round
  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'  
  has_one :result, dependent: :destroy
  default_scope { includes(:tournament).includes(:team1).order("date desc","teams.event_id asc") }

end
