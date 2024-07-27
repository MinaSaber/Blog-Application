FactoryBot.define do
  factory :user do
    name { "username" }
    email { "user@gmail.com" }
    password { "password" }
    image { "image_url" }
  end
end
