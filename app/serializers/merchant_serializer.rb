class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
  has_many :items, lazy_load_data: true
end
