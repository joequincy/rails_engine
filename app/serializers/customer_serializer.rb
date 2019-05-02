class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name
  has_many :invoices, lazy_load_data: true
end
