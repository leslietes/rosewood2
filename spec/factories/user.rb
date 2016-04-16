FactoryGirl.define do
  factory :user do |f|
    f.email "admin@example.com"
    f.password "secret123"
  end
end