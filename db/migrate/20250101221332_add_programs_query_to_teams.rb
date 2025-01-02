class AddProgramsQueryToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :programs_query, :string
  end
end
