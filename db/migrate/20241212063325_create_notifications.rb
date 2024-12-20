class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :user, null: true, foreign_key: {to_table: "memberships"}
      t.datetime :read_at
      t.boolean :emailed, default: false

      t.timestamps
    end
  end
end
