FactoryGirl.define do
  factory :room do |f|
    f.room_no 101
    f.max_occupants 2
    f.room_rate 8000
  end
  
  factory :invalid_room, parent: :room do |f|
    f.room_no 102
    f.max_occupants nil
    f.room_rate nil
  end
end