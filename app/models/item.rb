class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.best_day(id)
    select("to_char(invoices.created_at, 'YYYY-MM-DD') as best_day")
    .joins(invoice_items: {invoice: :transactions})
    .merge(Transaction.successful)
    .where(items: {id: id})
    .group('best_day')
    .order('sum(invoice_items.quantity * invoice_items.unit_price) desc, best_day desc')
    .take
  end
end
