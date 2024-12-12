class AddGroupsQueryToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :groups_query, :string
  end
end
