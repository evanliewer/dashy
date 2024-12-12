class CreateWebsiteimages < ActiveRecord::Migration[7.2]
  def change
    create_table :websiteimages do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
