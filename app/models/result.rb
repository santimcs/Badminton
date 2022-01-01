class Result < ApplicationRecord
  belongs_to :match
  default_scope { includes(:match).order("matches.date desc") }
  # Getter
  def game1
      [game11, game12].join('-')
  end
  def game2
      [game21, game22].join('-')
  end
  def game3
  	if !game31.nil?
      [game31, game32].join('-')
    else
    	' '
    end
  end
  def game
   	if !game3.blank?
      [game1, game2, game3].join(',')
    else
      [game1, game2].join(',')
    end 	
  end

end
