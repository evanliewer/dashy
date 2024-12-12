class AddDescriptionAndExternalAndPreflightToFlights < ActiveRecord::Migration[7.2]
  def change
    add_column :flights, :description, :string
    add_column :flights, :external, :boolean, default: false
    add_column :flights, :preflight, :boolean, default: false
  end
end
