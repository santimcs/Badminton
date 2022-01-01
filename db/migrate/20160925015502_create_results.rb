class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :match, foreign_key: true
      t.integer :game11, default: 0
      t.integer :game12, default: 0
      t.integer :game21, default: 0
      t.integer :game22, default: 0
      t.integer :game31
      t.integer :game32

      t.timestamps
    end
  end
end
