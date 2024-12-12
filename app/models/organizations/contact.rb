class Organizations::Contact < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :retreats_assigned_contacts, class_name: "Retreats::AssignedContact", dependent: :destroy, foreign_key: :organizations_contact_id, inverse_of: :organizations_contact
  has_many :retreats, through: :retreats_assigned_contacts
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :first_name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
