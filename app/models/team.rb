class Team < ApplicationRecord
  has_many :entries, dependent: :destroy
  belongs_to :event
  belongs_to :player1, :class_name => 'Player'
  belongs_to :player2, :class_name => 'Player'  
	#default_scope { includes(:event).order("events.abbr asc") }

  # Getter
  def team_name
    if player2.first_name != "Anonymous"
      [event.abbr, player1.full_name, player2.full_name].join(' / ')
    else
      [event.abbr, player1.full_name].join(' / ')
    end

  end
  
  # Setter
  def team_name=(name)
    split = name.split(' / ', 3)
    self.event.abbr = split.first
    self.player1.name = split.second
    self.player2.name = split.last
  end

end
