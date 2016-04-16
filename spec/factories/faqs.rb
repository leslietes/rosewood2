FactoryGirl.define do
  factory :faq do |f|
    f.question "Why?"
    f.answer   "Because.."
  end
  
  factory :invalid_faq, parent: :faq do |f|
    f.question ""
    f.answer   ""
  end
end