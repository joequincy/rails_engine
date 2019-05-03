require 'rails_helper'

describe 'Customers API Business Analysis' do
  it 'gets the merchant with whom the customer has conducted the most successful transactions' do
    merchants = create_list(:merchant, 4)
    customer = create(:customer)

    (1..4).each do |i|
      invoice = create(:invoice, merchant: merchants[2], customer: customer)
      create(:transaction, invoice: invoice)
    end

    (1..2).each do |i|
      invoice = create(:invoice, merchant: merchants[1], customer: customer)
      create(:transaction, invoice: invoice)
      invoice = create(:invoice, merchant: merchants[3], customer: customer)
      create(:transaction, invoice: invoice)
    end

    (1..3).each do |i|
      invoice = create(:invoice, merchant: merchants[1], customer: customer)
      create(:transaction, invoice: invoice, result: :failed)
    end

    get api_v1_customer_favorite_merchant_path(customer)

    result = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(result['id']).to eq(merchants[2].id)
    expect(result['name']).to eq(merchants[2].name)
  end
end
