FactoryGirl.define do 
  factory :checkin do |f|
    f.room_id    1
    f.room_no    201
    f.start_date Date.today
    f.user_id    1
    f.checkout   false
  end
end
