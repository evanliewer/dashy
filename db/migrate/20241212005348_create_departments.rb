class CreateDepartments < ActiveRecord::Migration[7.2]
  def change
    create_table :departments do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.boolean :dashboard, default: false

      t.timestamps
    end
  end
end
