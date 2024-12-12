class AddCircuitreeApiToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :circuitree_api, :string
  end
end
