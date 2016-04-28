FactoryGirl.define do
  factory :faq do |f|
    f.question "Why?"
    f.answer   "Because.."
    f.user_id  1
  end
  
  factory :invalid_faq, parent: :faq do |f|
    f.question ""
    f.answer   ""
    f.user_id  1
  end
end