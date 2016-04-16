# spec/factories/occupants.rb
require 'faker'

FactoryGirl.define do
  factory :occupant do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name  { Faker::Name.last_name }
    f.waiting true
    f.birthdate  { 21.years.ago}
    f.address1 "7 Washington Avenue"
    f.city     "Riverwood"
    f.province "NSW"
    f.postcode 2210
  end
  
  factory :occupant1, parent: :occupant do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name  { Faker::Name.last_name }
  end
  
  factory :occupant2, parent: :occupant do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name  { Faker::Name.last_name }
  end
  
  factory :invalid_occupant, parent: :occupant do |f|
    f.first_name ''
    f.last_name  ''
  end
  
end