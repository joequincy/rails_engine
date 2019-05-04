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

  def self.merchant_revenue(id, date = nil)
    query = revenue_query
            .where('merchants.id = ?', id)

    query = query.where("date_trunc('day', invoices.created_at) = ?", date) if date
    query.take
  end

  def self.date_revenue(date)
    revenue_query
    .where("date_trunc('day',invoices.updated_at) = ?", date)
    .take
  end

  def self.top_by_revenue(limit)
    top_by
  	.order('sum(invoice_items.quantity * invoice_items.unit_price) desc')
    .limit(limit)
  end

  def self.top_by_items(limit)
    top_by
  	.order('sum(invoice_items.quantity) desc')
    .limit(limit)
  end

  private

  def self.revenue_query
    select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
  end

  def self.top_by
    joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
  end
end
