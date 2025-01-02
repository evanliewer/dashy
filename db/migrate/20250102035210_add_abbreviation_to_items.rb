class AddAbbreviationToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :abbreviation, :string
  end
end
