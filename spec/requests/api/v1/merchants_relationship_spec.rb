require 'rails_helper'

describe 'Merchants API Relationship Endpoints' do
  before(:context) do
    @m1 = Merchant.create(name: "Merchant")
    @m2 = Merchant.create(name: "Shopkeep")

    c1 = Customer.create(first_name: "Robert'); DROP TABLE Students;--", last_name: "Roberts")

    @m1_invoices = create_list(:invoice, 4, customer: c1, merchant: @m1)
    @m2_invoices = create_list(:invoice, 6, customer: c1, merchant: @m2)

    @m1_items = create_list(:item, 1, merchant: @m1)
    @m2_items = create_list(:item, 3, merchant: @m2)

    @timestamp_columns = ['created_at', 'updated_at']
  end

  def attributes(obj)
    case obj.class.name
    when "Array" then obj.first['attributes'].keys.sort
    when "Class" then obj.column_names.sort - @timestamp_columns
    end
  end

  it 'returns a collection of invoices for a single merchant' do
    get api_v1_merchant_invoices_path(@m1)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(results.count).to eq(4)

    expect(attributes(results)).to eq(attributes(Invoice))
    expect(results.last['attributes']['id']).to eq(@m1_invoices.last.id)

    test_invoice = Invoice.find(results.first['attributes']['id'])
    expect(test_invoice).to eq(@m1_invoices.first)
  end

  it 'returns a collection of items for a single merchant' do
    get api_v1_merchant_items_path(@m2)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(results.count).to eq(3)

    expect(attributes(results)).to eq(attributes(Item))
    expect(results.last['attributes']['id']).to eq(@m2_items.last.id)

    test_item = Item.find(results.first['attributes']['id'])
    expect(test_item).to eq(@m2_items.first)
  end

  after(:context) do
    Item.destroy_all
    Invoice.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end
end
