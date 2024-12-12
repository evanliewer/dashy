class Medform < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat, optional: true
  belongs_to :diet, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :address, class_name: "Address", as: :addressable
  accepts_nested_attributes_for :address
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :retreat, scope: true
  validates :diet, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_retreats
    team.retreats
  end

  def valid_diets
    team.diets
  end

  # 🚅 add methods above.
end
