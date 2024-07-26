class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, foreign_key: "post_id", dependent: :destroy
  has_many :tags, foreign_key: "post_id", dependent: :destroy, inverse_of: :post
  validates :title, presence: true
  validates :body, presence: true
  validate :validate_tags_presence

  after_create :schedule_deletion

  accepts_nested_attributes_for :tags, allow_destroy: true

  def custom_post_parameters
    {
      title: title,
      body: body,
      tags_attributes: tags.map(&:custom_tag_parameters),
      comments: comments.map(&:custom_comment_parameters)
    }
  end

  private

  def validate_tags_presence
    remaining_tags = tags.reject(&:marked_for_destruction?).count
    if remaining_tags < 1
      errors.add(:tags, "must have at least one tag")
    end
  end

  def schedule_deletion
    DeletePostJob.set(wait: 24.hours).perform_later(self.id)
  end
end
