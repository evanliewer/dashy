class Item < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :image_tag_removal
  attr_accessor :layout_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :location, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one_attached :image_tag
  has_one_attached :layout
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :location, scope: true
  # 🚅 add validations above.

  after_validation :remove_image_tag, if: :image_tag_removal?
  after_validation :remove_layout, if: :layout_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_locations
    team.locations
  end

  def image_tag_removal?
    image_tag_removal.present?
  end

  def remove_image_tag
    image_tag.purge
  end

  def layout_removal?
    layout_removal.present?
  end

  def remove_layout
    layout.purge
  end

  # 🚅 add methods above.
end
