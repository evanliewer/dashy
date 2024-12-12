class Avo::Resources::FlightsTimeframe < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Flights::Timeframe
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
  end
end
