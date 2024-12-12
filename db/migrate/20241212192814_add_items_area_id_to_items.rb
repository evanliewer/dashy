class AddItemsAreaIdToItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :items, :items_area, null: true, foreign_key: {to_table: "items_areas"}
  end
end
