factory :comment do
  comment { "Sample Comment" }
  association :user
  association :post
end
