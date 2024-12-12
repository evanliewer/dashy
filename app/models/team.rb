class Team < ApplicationRecord
  include Teams::Base
  include Webhooks::Outgoing::TeamSupport
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  has_many :demographics, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :organizations, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :retreats, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :items_tags, class_name: "Items::Tag", dependent: :destroy
  has_many :flights, dependent: :destroy
  has_many :flights_timeframes, class_name: "Flights::Timeframe", dependent: :destroy
  has_many :flights_checks, class_name: "Flights::Check", dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
