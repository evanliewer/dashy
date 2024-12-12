class AddWarningAlertToFlights < ActiveRecord::Migration[7.2]
  def change
    add_column :flights, :warning_alert, :integer
  end
end
