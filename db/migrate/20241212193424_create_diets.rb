class CreateDiets < ActiveRecord::Migration[7.2]
  def change
    create_table :diets do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name

      t.timestamps
    end
  end
end
