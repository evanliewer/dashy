# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::FlightsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :flight, through: :team, through_association: :flights

    # GET /api/v1/teams/:team_id/flights
    def index
    end

    # GET /api/v1/flights/:id
    def show
    end

    # POST /api/v1/teams/:team_id/flights
    def create
      if @flight.save
        render :show, status: :created, location: [:api, :v1, @flight]
      else
        render json: @flight.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/flights/:id
    def update
      if @flight.update(flight_params)
        render :show
      else
        render json: @flight.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/flights/:id
    def destroy
      @flight.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def flight_params
        strong_params = params.require(:flight).permit(
          *permitted_fields,
          :name,
          :description,
          :external,
          :preflight,
          :warning_alert,
          :flights_timeframe_id,
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
  class Api::V1::FlightsController
  end
end
