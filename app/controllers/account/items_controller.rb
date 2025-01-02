class Account::ItemsController < Account::ApplicationController
  account_load_and_authorize_resource :item, through: :team, through_association: :items


  # GET /account/teams/:team_id/items
  # GET /account/teams/:team_id/items.json
  def index
    if params[:tag].present?
      @items = Item.joins(:tags).where(tags: { name: params[:tag] })
    else 
      @items = Item.where.not(id: Item.joins(:tags).where("tags.name ILIKE ?", "%Amenity%").where(tags: { name: ['Lodging','Meeting Spaces'] }).select(:id))  
    end

    delegate_json_to_api
  end

  # GET /account/items/:id
  # GET /account/items/:id.json
  def show
    @previous_reservations = Reservation
                            .where(item_id: @item.id)
                            .where("start_time < ?", Time.zone.now)
                            .order(start_time: :desc)
                            .limit(5)
    @next_reservations = Reservation
                        .where(item_id: @item.id)
                        .where("start_time >= ?", Time.zone.now)
                        .order(start_time: :asc)
                        .limit(5)
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/items/new
  def new
  end

  # GET /account/items/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/items
  # POST /account/teams/:team_id/items.json
  def create
    respond_to do |format|
      if @item.save
        format.html { redirect_to [:account, @item], notice: I18n.t("items.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @item] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/items/:id
  # PATCH/PUT /account/items/:id.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        if @item.active
          format.html { redirect_to [:account, @item], notice: I18n.t("items.notifications.updated") }
          format.json { render :show, status: :ok, location: [:account, @item] }
        else
          format.html { redirect_to [:account, @team, :items], notice: I18n.t("items.notifications.updated") }
          format.json { render :show, status: :ok, location: [:account, @team, :items] }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/items/:id
  # DELETE /account/items/:id.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :items], notice: I18n.t("items.notifications.destroyed") }
      format.json { head :no_content }
    end
  end


  def lodging
    @team = current_team
    @item = Item.last
    @given_date = params[:date].present? ? params[:date].to_date : Date.today
   # @cabins = Item.joins(:tags).where(tags: { name: 'Lodging' }).pluck(:id)
   # cabin_ids = @cabins.pluck(:id)
    

      #Reservations for unique lodging items
    @reservations1 = Reservation
      .where(item_id: Item.joins(:tags).where(tags: { name: 'Lodging' }).pluck(:id))  # Filter by all item IDs
      .where('end_time > ?', @given_date)  # Ensure end_time is in the future
      .select('DISTINCT ON (item_id) *')  # Ensure only one reservation per item
      .order('item_id, start_time ASC')  # First order by item_id, then by start_time

    @reservations = Reservation
  .joins(item: :area)  # Joins items and areas
  .where(item_id: Item.joins(:tags).where(tags: { name: 'Lodging' }).pluck(:id))  # Filter by item tags
  .where('reservations.end_time > ?', @given_date)  # Ensure end_time is in the future
  .select('DISTINCT ON (reservations.item_id) reservations.*')  # Get one reservation per item_id
  .order('reservations.item_id, reservations.start_time ASC')  # Order by item_id, then start_time


 
  #Only Open
    @reservations2 = Reservation
      .where(item_id: Item.joins(:tags).where(tags: { name: 'Lodging' }).pluck(:id))  # Filter by all item IDs
      .where('end_time > ?', @given_date) 
      .where.not('? BETWEEN start_time AND end_time', Time.zone.now)
      .select('DISTINCT ON (item_id) *')  # Ensure only one reservation per item
      .order('item_id, start_time ASC')  # First order by item_id, then by start_time
  end

  def cleaning
    @team = current_team
    @item = Item.last
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_select_options(strong_params, :tag_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
