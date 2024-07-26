class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, foreign_key: "post_id", dependent: :destroy
  has_many :tags, foreign_key: "post_id", dependent: :destroy, inverse_of: :post
  validates :title, presence: true
  validates :body, presence: true


  accepts_nested_attributes_for :tags, allow_destroy: true
end
