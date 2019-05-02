FactoryBot.define do
  factory :invoice_item do
    item { create(:item) }
    invoice { create(:invoice) }
    quantity { 1 }
    unit_price { 1 }
    sequence(:created_at) {|n| n.days.ago.strftime('%Y-%m-%d %H:%M:%S')}
    updated_at { DateTime.now.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
