class Entry < ApplicationRecord
  self.primary_keys = :tournament_id, :team_id
  belongs_to :tournament
  belongs_to :team
  default_scope { includes(:team).order("teams.event_id","rank asc") }
  # Getter
  def entry_name
    if team.player2.first_name != "Anonymous"
      [team.event.abbr, rank, team.player1.full_name, team.player2.full_name, team_id.to_s].join(' / ')
    else
      [team.event.abbr, rank, team.player1.full_name].join(' / ')
    end

  end
end
