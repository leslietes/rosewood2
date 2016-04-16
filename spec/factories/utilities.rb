FactoryGirl.define do
  factory :utility do |f|
    f.name "Water"
    f.category "Basic"
  end
  
  factory :invalid_utility, parent: :utility do |f|
    f.name ""
    f.category ""
  end
  
  factory :extra, parent: :utility do |f|
    f.name "Parking Fee"
    f.category "Extra"
  end
end