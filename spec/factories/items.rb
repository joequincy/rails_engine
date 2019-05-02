FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "Item #{n}" }
    description { "Item Description" }
    unit_price { 1 }
    merchant { create(:merchant) }
  end
end
