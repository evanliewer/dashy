class AddProgramEventToRetreats < ActiveRecord::Migration[7.2]
  def change
    add_column :retreats, :program_event, :boolean, default: false
  end
end
