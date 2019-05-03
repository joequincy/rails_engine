require 'rails_helper'

describe 'Invoices API Relationship Endpoints' do
  before(:context) do
    @m = create_list(:merchant, 2)
    @c = create_list(:customer, 2)

    @items1 = create_list(:item, 3, merchant: @m[0])
    @items2 = create_list(:item, 2, merchant: @m[1])

    @invoice1 = create(:invoice, merchant: @m[0], customer: @c[0])
    @invoice2 = create(:invoice, merchant: @m[1], customer: @c[0])
    @invoice3 = create(:invoice, merchant: @m[0], customer: @c[1])
    @invoice4 = create(:invoice, merchant: @m[1], customer: @c[1])

    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @items1[1])
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @items1[2])

    @invoice_item3 = create(:invoice_item, invoice: @invoice2, item: @items2[1])

    @invoice_item4 = create(:invoice_item, invoice: @invoice3, item: @items1[0])
    @invoice_item5 = create(:invoice_item, invoice: @invoice3, item: @items1[2])
    @invoice_item6 = create(:invoice_item, invoice: @invoice3, item: @items1[1])

    @invoice_item7 = create(:invoice_item, invoice: @invoice4, item: @items2[1])
    @invoice_item8 = create(:invoice_item, invoice: @invoice4, item: @items2[0])

    @transaction1 = create(:transaction, invoice: @invoice1, result: :failed)
    @transaction2 = create(:transaction, invoice: @invoice1, result: :success)

    @transaction3 = create(:transaction, invoice: @invoice3, result: :success)

    @transaction4 = create(:transaction, invoice: @invoice4, result: :failed)

    @timestamp_columns = ['created_at', 'updated_at']
  end

  def attributes(obj)
    case obj.class.name
    when "Hash" then obj['attributes'].keys.sort
    when "Array" then obj.first['attributes'].keys.sort
    when "Class" then obj.column_names.sort - @timestamp_columns
    end
  end

  it 'returns a collection of transactions for a single invoice' do
    get api_v1_invoice_transactions_path(@invoice1)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(results)).to eq(attributes(Transaction) - ["credit_card_expiration_date"])

    attributes(results).each do |attribute|
      expect(results.first['attributes'][attribute]).to eq(@transaction1[attribute])
    end

    test_transaction = Transaction.find(results.first['attributes']['id'])
    expect(test_transaction).to eq(@transaction1)
  end

  it 'returns a collection of invoice_items for a single invoice' do
    get api_v1_invoice_invoice_items_path(@invoice3)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(results)).to eq(attributes(InvoiceItem))

    attributes(results).each do |attribute|
      unless attribute == 'unit_price'
        expect(results.first['attributes'][attribute]).to eq(@invoice_item4[attribute])
      else
        expect(results.first['attributes'][attribute]).to eq((@invoice_item4[attribute] / 100.0).to_s)
      end
    end

    test_invoice_item = InvoiceItem.find(results.first['attributes']['id'])
    expect(test_invoice_item).to eq(@invoice_item4)
  end

  it 'returns a collection of items for a single invoice' do
    get api_v1_invoice_items_path(@invoice3)

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(results)).to eq(attributes(Item))

    attributes(results).each do |attribute|
      unless attribute == 'unit_price'
        expect(results.first['attributes'][attribute]).to eq(@items1[0][attribute])
      else
        expect(results.first['attributes'][attribute]).to eq((@items1[0][attribute] / 100.0).to_s)
      end
    end

    test_invoice_item = Item.find(results.first['attributes']['id'])
    expect(test_invoice_item).to eq(@items1[0])
  end

  it 'returns the merchant for a single invoice' do
    get api_v1_invoice_merchant_path(@invoice2)

    result = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(result)).to eq(attributes(Merchant))

    attributes(result).each do |attribute|
      expect(result['attributes'][attribute]).to eq(@m[1][attribute])
    end

    test_merchant = Merchant.find(result['attributes']['id'])
    expect(test_merchant).to eq(@m[1])
  end

  it 'returns the customer for a single invoice' do
    get api_v1_invoice_customer_path(@invoice4)

    result = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(result)).to eq(attributes(Customer))

    attributes(result).each do |attribute|
      expect(result['attributes'][attribute]).to eq(@c[1][attribute])
    end

    test_merchant = Customer.find(result['attributes']['id'])
    expect(test_merchant).to eq(@c[1])
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
