class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :website

      t.timestamps
    end
  end
end
