class Tournament < ApplicationRecord
  belongs_to :country
  belongs_to :category
  default_scope { order('fm_date DESC') }

  # Getter
  def name_year
  	name + ' ' + fm_date.year.to_s
  end

end
