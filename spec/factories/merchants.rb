FactoryBot.define do
  factory :merchant do
    sequence(:name) {|n| "Merchant #{n}" }
    sequence(:created_at) {|n| n.days.ago.strftime('%Y-%m-%d %H:%M:%S')}
    updated_at { DateTime.now.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
