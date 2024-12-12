class AddReservationDownloadToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :reservation_download, :string
  end
end
