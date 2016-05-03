FactoryGirl.define do
  factory :billing do |f|
    f.statement_date  '01-31-2016'
    f.room_month      'January'
    f.room_year       '2016'
    f.utilities_month 'February'
    f.utilities_year  '2016'
    f.user_id          1
  end
end
