require 'rails_helper'

describe 'InvoiceItems API Record Endpoints' do
  it 'sends a list of invoice_items' do
    create_list(:invoice_item, 3)
    get '/api/v1/invoice_items'

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items['data'].count).to eq(3)
  end

  it 'can get one invoice_item by its id' do
    id = create(:invoice_item).id
    get api_v1_invoice_item_path(id)

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item['data']['id'].to_i).to eq(id)
  end

  it 'can get a random invoice_item' do
    invoice_items = create_list(:invoice_item, 10)

    get api_v1_invoice_items_random_path

    invoice_item = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    record = InvoiceItem.find(invoice_item['id'])
    expect(invoice_item['invoice_id']).to eq(record.invoice_id)
    expect(invoice_item['item_id']).to eq(record.item_id)
  end

  it 'can find one invoice_item by its attributes' do
    invoice_items = create_list(:invoice_item, 3)
    get api_v1_invoice_items_find_path(id: invoice_items[0].id)
    invoice_item = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(invoice_item['invoice_id']).to eq(invoice_items[0].invoice_id)

    get api_v1_invoice_items_find_path(invoice_id: invoice_items[1].invoice_id)
    invoice_item = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(invoice_item['invoice_id']).to eq(invoice_items[1].invoice_id)
  end

  it 'can find multiple invoice_items by their attributes' do
    invoice = create(:invoice)
    invoice_items = create_list(:invoice_item, 3, invoice: invoice)
    get api_v1_invoice_items_find_all_path(id: invoice_items[0].id)
    invoice_item_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(invoice_item_list.count).to eq(1)
    expect(invoice_item_list.first['attributes']['invoice_id']).to eq(invoice_items[0].invoice_id)

    get api_v1_invoice_items_find_all_path(invoice_id: invoice_items[1].invoice_id)
    invoice_item_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(invoice_item_list.count).to eq(3)
    expect(invoice_item_list.first['attributes']['invoice_id']).to eq(invoice_items[1].invoice_id)
  end
end
