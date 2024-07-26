class Tag < ApplicationRecord
  belongs_to :post, inverse_of: :tags
  validates :tag, presence: true

  def custom_tag_parameters
    {
      tag: tag
    }
  end
end
