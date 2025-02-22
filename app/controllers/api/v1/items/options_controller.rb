# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Items::OptionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :option, through: :item, through_association: :options

    # GET /api/v1/items/:item_id/options
    def index
    end

    # GET /api/v1/items/options/:id
    def show
    end

    # POST /api/v1/items/:item_id/options
    def create
      if @option.save
        render :show, status: :created, location: [:api, :v1, @option]
      else
        render json: @option.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/items/options/:id
    def update
      if @option.update(option_params)
        render :show
      else
        render json: @option.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/items/options/:id
    def destroy
      @option.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def option_params
        strong_params = params.require(:items_option).permit(
          *permitted_fields,
          :name,
          :capacity,
          :image_tag,
          :image_tag_removal,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::Items::OptionsController
  end
end
