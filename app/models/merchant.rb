class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.customer_favorite(customer_id)
    joins(invoices: [:customer, :transactions])
    .merge(Transaction.successful)
    .where(customers: {id: customer_id})
    .group(:id)
    .order("COUNT(transactions.id) DESC")
    .take
  end
end
