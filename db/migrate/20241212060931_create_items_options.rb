class CreateItemsOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :items_options do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.integer :capacity

      t.timestamps
    end
  end
end
