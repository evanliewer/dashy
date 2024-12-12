class AddDescriptionToItemsOptions < ActiveRecord::Migration[7.2]
  def change
    add_column :items_options, :description, :string
  end
end
