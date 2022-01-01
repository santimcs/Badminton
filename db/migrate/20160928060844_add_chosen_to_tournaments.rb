class AddChosenToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :chosen, :boolean, default: false
  end
end
