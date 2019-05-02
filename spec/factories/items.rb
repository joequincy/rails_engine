FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "Item #{n}" }
    description { "Item Description" }
    unit_price { 1 }
    merchant { create(:merchant) }
    sequence(:created_at) {|n| n.days.ago.strftime('%Y-%m-%d %H:%M:%S')}
    updated_at { DateTime.now.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
