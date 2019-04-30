require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    get api_v1_merchants_path

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(3)
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get api_v1_merchant_path(id)

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant['id']).to eq(id)
  end
end
