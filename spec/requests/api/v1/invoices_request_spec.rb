require 'rails_helper'

describe 'Invoices API Record Endpoints' do
  it 'sends a list of invoices' do
    create_list(:invoice, 3)
    get api_v1_invoices_path

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices['data'].count).to eq(3)
  end

  it 'can get one invoice by its id' do
    id = create(:invoice).id
    get api_v1_invoice_path(id)

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice['data']['id'].to_i).to eq(id)
  end

  it 'can find one invoice by its attributes' do
    invoices = create_list(:invoice, 3)
    get api_v1_invoices_find_path(id: invoices[0].id)
    invoice = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(invoice['status']).to eq(invoices[0].status)

    get api_v1_invoices_find_path(status: invoices[1].status)
    invoice = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(invoice['status']).to eq(invoices[1].status)
  end

  it 'can find multiple invoices by their attributes' do
    invoices = create_list(:invoice, 3, status: :shipped)
    get api_v1_invoices_find_all_path(id: invoices[0].id)
    invoice_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(invoice_list.count).to eq(1)
    expect(invoice_list.first['attributes']['status']).to eq(invoices[0].status)

    get api_v1_invoices_find_all_path(status: invoices[1].status)
    invoice_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(invoice_list.count).to eq(3)
    expect(invoice_list.first['attributes']['status']).to eq(invoices[1].status)
  end
end
