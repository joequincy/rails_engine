FactoryBot.define do
  factory :invoice do
    customer { create(:customer) }
    merchant { create(:merchant) }
    status { :shipped }
    sequence(:created_at) {|n| n.days.ago.strftime('%Y-%m-%d %H:%M:%S')}
    updated_at { DateTime.now.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
