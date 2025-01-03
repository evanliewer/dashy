class AddPlannedCleaningDateToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :planned_cleaning_date, :date
  end
end
