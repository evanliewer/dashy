class Websiteimage < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :image_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one_attached :image
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  after_validation :remove_image, if: :image_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def image_removal?
    image_removal.present?
  end

  def remove_image
    image.purge
  end

  # 🚅 add methods above.
end
