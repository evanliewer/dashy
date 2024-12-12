class Items::Option < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  attr_accessor :image_tag_removal
  # 🚅 add attribute accessors above.

  belongs_to :item
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :item
  has_one_attached :image_tag
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  after_validation :remove_image_tag, if: :image_tag_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def image_tag_removal?
    image_tag_removal.present?
  end

  def remove_image_tag
    image_tag.purge
  end

  def collection
    item.options
  end

  # 🚅 add methods above.
end
