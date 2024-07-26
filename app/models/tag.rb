class Tag < ApplicationRecord
  belongs_to :post, inverse_of: :tags
  validates :tag, presence: true
end
