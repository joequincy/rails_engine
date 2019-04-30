FactoryBot.define do
  factory :transaction do
    invoice_id { nil }
    credit_card_number { 1 }
    credit_card_expiration_date { "2019-04-29" }
    result { 0 }
  end
end
