FactoryBot.define do
  factory :customer do
    first_name { "Bobby" }
    last_name { "Tables" }
    sequence(:created_at) {|n| n.days.ago.strftime('%Y-%m-%d %H:%M:%S')}
    updated_at { DateTime.now.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
