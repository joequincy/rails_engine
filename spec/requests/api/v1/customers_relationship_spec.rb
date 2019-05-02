require 'rails_helper'

describe 'Customers API Relationship Endpoints' do
  before(:context) do
    m = Merchant.create(name: "Merchant")
    @c1 = Customer.create(first_name: "Robert'); DROP TABLE Students;--", last_name: "Roberts")
    @c2 = Customer.create(first_name: "Help I'm trapped in a driver's license factory", last_name: "Roberts")

    @i1, @i2, @i3, @i4 = create_list(:invoice, 4, customer: @c1, merchant: m)
    @i5, @i6 = create_list(:invoice, 2, customer: @c2, merchant: m)

    @i1t_success = create(:transaction, invoice: @i1)
    @i1t_failure = create(:transaction, invoice: @i1, result: :failed)

    @i5t_success = create(:transaction, invoice: @i5)
    @i5t_failure = create(:transaction, invoice: @i5, result: :failed)
    @i6t_success = create(:transaction, invoice: @i6)
  end

  it 'returns a collection of invoices for a single customer' do
    get api_v1_customer_invoices_path(@c1.id)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(results.count).to eq(4)
    expect(results.first['attributes']['customer_id']).to eq(@c1.id)
  end

  it 'returns a collection of transactions for a single customer' do
    get api_v1_customer_transactions_path(@c2)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(results.count).to eq(3)
    
    test_transaction = Transaction.find(results.first['attributes']['id'])
    expect(test_transaction.customer).to eq(@c2)
  end

  after(:context) do
    Transaction.destroy_all
    Invoice.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end
end
