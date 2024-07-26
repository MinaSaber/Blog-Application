class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :comment, presence: true

  def custom_comment_parameters
    {
      comment: comment
    }
  end
end
