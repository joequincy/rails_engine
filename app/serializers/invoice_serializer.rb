class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :customer_id, :merchant_id, :status
  has_many :transactions, lazy_load_data: true
end
