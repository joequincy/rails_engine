require 'rails_helper'

describe 'InvoiceItems API Relationship Endpoints' do
  before(:context) do
    m = create(:merchant)
    @invoices = create_list(:invoice, 2, merchant: m)
    @items = create_list(:item, 2, merchant: m)

    @i1 = create(:invoice_item, invoice: @invoices[0], item: @items[0])
    @i2 = create(:invoice_item, invoice: @invoices[0], item: @items[1])
    @i3 = create(:invoice_item, invoice: @invoices[1], item: @items[0])
    @i4 = create(:invoice_item, invoice: @invoices[1], item: @items[1])

    @timestamp_columns = ['created_at', 'updated_at']
  end

  def attributes(obj)
    case obj.class.name
    when "Hash" then obj['attributes'].keys.sort
    when "Class" then obj.column_names.sort - @timestamp_columns
    end
  end

  it 'returns the invoice for a single invoice_item' do
    get api_v1_invoice_item_invoice_path(@i1)

    result = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(result)).to eq(attributes(Invoice))
    expect(result['attributes']['id']).to eq(@invoices[0].id)

    test_invoice = Invoice.find(result['attributes']['id'])
    expect(test_invoice).to eq(@i1.invoice)
  end

  it 'returns the transaction for a single invoice_item' do
    get api_v1_invoice_item_item_path(@i4)

    result = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(attributes(result)).to eq(attributes(Item))
    expect(result['attributes']['id']).to eq(@items[1].id)

    test_item = Item.find(result['attributes']['id'])
    expect(test_item).to eq(@i4.item)
  end

  after(:context) do
    InvoiceItem.destroy_all
    Item.destroy_all
    Invoice.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
  end
end
