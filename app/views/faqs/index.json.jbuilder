json.array!(@faqs) do |faq|
  json.extract! faq, :id
  json.url faq_url(faq, format: :json)
end
