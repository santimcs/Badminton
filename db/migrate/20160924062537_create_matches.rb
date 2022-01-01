class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :tournament, foreign_key: true
      t.date :date
      t.references :round, foreign_key: true
      t.integer :team1_id
      t.integer :team2_id

      t.timestamps
    end
  end
end
