class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.references :event, foreign_key: true
      t.integer :rank
      t.integer :player1_id
      t.integer :player2_id

    end
  end
end
