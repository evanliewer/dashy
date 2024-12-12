class Avo::Resources::Medform < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :retreat, as: :belongs_to
    field :phone, as: :text
    field :email, as: :text
    field :gender, as: :text
    field :emergency_contact_name, as: :text
    field :emergency_contact_phone, as: :text
    field :emergency_contact_relationship, as: :text
    field :terms, as: :boolean
    field :form_for, as: :text
    field :age, as: :text
    field :diet, as: :belongs_to
  end
end
