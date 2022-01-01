class AddCategoryIdToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :category_id, :integer
  end
end
