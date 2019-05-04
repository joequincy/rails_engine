require 'rails_helper'

describe 'Items API Relationship Endpoints' do
  before(:context) do
    @m = create(:merchant)
    @invoices = create_list(:invoice, 2, merchant: @m)
    @items = create_list(:item, 2, merchant: @m)

    @i1 = create(:invoice_item, invoice: @invoices[0], item: @items[0])
    @i2 = create(:invoice_item, invoice: @invoices[0], item: @items[1])
    @i3 = create(:invoice_item, invoice: @invoices[1], item: @items[0])
    @i4 = create(:invoice_item, invoice: @invoices[1], item: @items[1])

    @timestamp_columns = ['created_at', 'updated_at']
  end

  def attributes(obj)
    case obj.class.name
    when "Hash" then obj['attributes'].keys.sort
    when "Array" then obj.first['attributes'].keys.sort
    when "Class" then obj.column_names.sort - @timestamp_columns
    end
  end

  it 'returns a collection of invoice_items for a single item' do
    get api_v1_item_invoice_items_path(@items[1])

    results = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(results)).to eq(attributes(InvoiceItem))

    attributes(results).each do |attribute|
      unless attribute == 'unit_price'
        expect(results.first['attributes'][attribute]).to eq(@i2[attribute])
      else
        expect(results.first['attributes'][attribute]).to eq((@i2[attribute] / 100.0).to_s)
      end
    end

    test_invoice_item = InvoiceItem.find(results.first['attributes']['id'])
    expect(test_invoice_item).to eq(@i2)
  end

  it 'returns the merchant for a single item' do
    get api_v1_item_merchant_path(@items[0])

    result = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(result)).to eq(attributes(Merchant))

    attributes(result).each do |attribute|
      expect(result['attributes'][attribute]).to eq(@m[attribute])
    end

    test_merchant = Merchant.find(result['attributes']['id'])
    expect(test_merchant).to eq(@m)
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
