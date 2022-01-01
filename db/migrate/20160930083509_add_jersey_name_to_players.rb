class AddJerseyNameToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :jersey_name, :string
  end
end
