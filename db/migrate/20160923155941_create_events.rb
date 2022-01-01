class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :abbr
      t.string :name
      t.integer :no_of_players
      t.integer :sequence

    end
  end
end
