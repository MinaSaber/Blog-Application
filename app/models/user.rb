class User < ApplicationRecord
    has_secure_password
    has_one_attached :image

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email" }
    validates :password, presence: true, length: { minimum: 8, message: "must have minimum 8 characters" }
    validates :image, presence: true

    def image_url
        Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
    end
end
