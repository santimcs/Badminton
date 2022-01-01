class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :fm_date
      t.date :to_date
      t.references :country, foreign_key: true

    end
  end
end
