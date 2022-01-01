class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.references :country, foreign_key: true
      t.string :image

    end
  end
end
