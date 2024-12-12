class CreateRetreats < ActiveRecord::Migration[7.2]
  def change
    create_table :retreats do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.datetime :arrival
      t.datetime :departure
      t.integer :contract_count
      t.references :organization, null: true, foreign_key: true
      t.boolean :internal, default: false
      t.boolean :active, default: false
      t.integer :actual_count
      t.integer :nps
      t.string :debrief
      t.string :dining_style

      t.timestamps
    end
  end
end
