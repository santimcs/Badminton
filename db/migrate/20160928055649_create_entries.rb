class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries, {:id => false } do |t|
      t.references :tournament, foreign_key: true
      t.references :team, foreign_key: true
      t.integer :rank
    end
    add_index :entries, [:tournament_id, :team_id], unique: true
  end
end
