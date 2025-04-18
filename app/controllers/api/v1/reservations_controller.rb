# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ReservationsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :reservation, through: :team, through_association: :reservations

    # GET /api/v1/teams/:team_id/reservations
    def index
    end

    # GET /api/v1/reservations/:id
    def show
    end

    # POST /api/v1/teams/:team_id/reservations
    def create
      if @reservation.save
        render :show, status: :created, location: [:api, :v1, @reservation]
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/reservations/:id
    def update
      if @reservation.update(reservation_params)
        render :show
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/reservations/:id
    def destroy
      @reservation.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def reservation_params
        strong_params = params.require(:reservation).permit(
          *permitted_fields,
          :name,
          :retreat_id,
          :item_id,
          :user_id,
          :start_time,
          :end_time,
          :quantity,
          :notes,
          :seasonal_default,
          :exclusive,
          :active,
          :dining_style,
          :items_option_id,
          :planned_cleaning_date,
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
  class Api::V1::ReservationsController
  end
end
