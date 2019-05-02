FactoryBot.define do
  factory :transaction do
    invoice { create(:invoice) }
    credit_card_number { 1 }
    credit_card_expiration_date { "2019-04-29" }
    result { 0 }
  end
end
