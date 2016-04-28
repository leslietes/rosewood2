FactoryGirl.define do
  factory :utility do |f|
    f.name "Water"
    f.category "Basic"
    f.user_id  1
    f.first_limit 10
    f.first_rate  150
    f.excess_rate 20
  end
  
  factory :electricity, parent: :utility do |f|
    f.name "Electricity"
    f.category    "Basic"
    f.user_id     1
    f.first_limit 11
  end
  
  factory :room_rate, parent: :utility do |f|
    f.name "Room Rate"
    f.category "Basic"
    f.user_id  1
  end
  
  factory :invalid_utility, parent: :utility do |f|
    f.name ""
    f.category ""
    f.user_id  1
  end
  
  factory :extra, parent: :utility do |f|
    f.name "Parking Fee"
    f.category "Extra"
    f.user_id  1
  end
end