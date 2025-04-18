class Api::V1::TeamsController < Api::V1::ApplicationController
  include Api::V1::Teams::ControllerBase

  private

  def permitted_fields
    [
      :item_query,
      :circuitree_api,
      :groups_query,
      :reservation_download,
      :programs_query,
      # 🚅 super scaffolding will insert new fields above this line.
    ]
  end

  def permitted_arrays
    {
      # 🚅 super scaffolding will insert new arrays above this line.
    }
  end

  def process_params(strong_params)
    strong_params
  end
end
