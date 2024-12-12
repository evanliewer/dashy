class Retreat < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :organization, optional: true
  # 🚅 add belongs_to associations above.

  has_many :location_tags, class_name: "Retreats::LocationTag", dependent: :destroy
  has_many :locations, through: :location_tags
  has_many :demographic_tags, class_name: "Retreats::DemographicTag", dependent: :destroy
  has_many :demographics, through: :demographic_tags
  has_many :planner_tags, class_name: "Retreats::PlannerTag", dependent: :destroy
  has_many :planners, through: :planner_tags, class_name: "Membership"
  has_many :host_tags, class_name: "Retreats::HostTag", dependent: :destroy
  has_many :hosts, through: :host_tags, class_name: "Membership"
  has_many :assigned_contacts, class_name: "Retreats::AssignedContact", dependent: :destroy
  has_many :organizations_contacts, through: :assigned_contacts, class_name: "Organizations::Contact"
  has_many :comments, class_name: "Retreats::Comment", dependent: :destroy, enable_cable_ready_updates: true
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :organization, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_organizations
    team.organizations
  end

  def valid_locations
    team.locations
  end

  def valid_demographics
    team.demographics
  end

  def valid_planners
    team.memberships.current_and_invited
  end

  def valid_hosts
    team.memberships.current_and_invited
  end

  def valid_contacts
    team.organizations_contacts
  end

  # 🚅 add methods above.
end
