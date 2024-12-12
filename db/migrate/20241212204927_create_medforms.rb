class CreateMedforms < ActiveRecord::Migration[7.2]
  def change
    create_table :medforms do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :retreat, null: true, foreign_key: true
      t.string :phone
      t.string :email
      t.string :gender
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.string :emergency_contact_relationship
      t.boolean :terms, default: false
      t.string :form_for
      t.string :age
      t.references :diet, null: true, foreign_key: true

      t.timestamps
    end
  end
end
