FactoryBot.define do
  factory :post do
    title { "Sample Post Title" }
    body { "Sample Post Body" }
    association :user
  end
end
