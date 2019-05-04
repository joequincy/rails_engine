class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  scope :by_merchant, ->(merchant_id){ where(merchants: {id: merchant_id})
                                       .group(:id) }

  def self.merchant_favorite(merchant_id)
    joins(invoices: [:merchant, :transactions])
    .merge(Transaction.successful)
    .merge(Customer.by_merchant(merchant_id))
    .order("COUNT(transactions.id) DESC")
    .take
  end

  def self.in_debt_to(merchant_id)
    left_joins(invoices: [:merchant, :transactions])
    .merge(Customer.by_merchant(merchant_id))
    .having('count(distinct invoices.id) > count(*) filter(where transactions.result = 0)')
  end
end
