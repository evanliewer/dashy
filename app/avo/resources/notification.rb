class Avo::Resources::Notification < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :user, as: :belongs_to
    field :read_at, as: :date_time
    field :emailed, as: :boolean
  end
end
