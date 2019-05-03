require 'rails_helper'

describe 'Transactions API Relationship Endpoints' do
  before(:context) do
    @invoices = create_list(:invoice, 3)

    @transactions = []
    @transactions << create(:transaction, invoice: @invoices[0], result: :failed)
    @transactions << create(:transaction, invoice: @invoices[0], result: :success)
    @transactions << create(:transaction, invoice: @invoices[1], result: :success)

    @timestamp_columns = ['created_at', 'updated_at']
  end

  def attributes(obj)
    case obj.class.name
    when "Hash" then obj['attributes'].keys.sort
    when "Class" then obj.column_names.sort - @timestamp_columns
    end
  end

  it 'returns the invoice for a single transaction' do
    @transactions.each do |transaction|
      get api_v1_transaction_invoice_path(transaction)

      result = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(attributes(result)).to eq(attributes(Invoice))

      attributes(result).each do |attribute|
        expect(result['attributes'][attribute]).to eq(transaction.invoice[attribute])
      end

      test_invoice = Invoice.find(result['attributes']['id'])
      expect(test_invoice).to eq(transaction.invoice)
    end
  end

  after(:context) do
    Transaction.destroy_all
    InvoiceItem.destroy_all
    Item.destroy_all
    Invoice.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end
end
