class AddImageTagToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :image_tag, :string
  end
end
