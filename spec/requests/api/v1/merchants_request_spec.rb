require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    get api_v1_merchants_path

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants['data'].count).to eq(3)
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id
    get api_v1_merchant_path(id)

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant['data']['id'].to_i).to eq(id)
  end

  it 'can find one merchant by its attributes' do
    merchants = create_list(:merchant, 3)
    get api_v1_merchants_find_path(merchant: {id: merchants[0].id})
    merchant = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(merchant['name']).to eq(merchants[0].name)

    get api_v1_merchants_find_path(merchant: {name: merchants[1].name})
    merchant = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(merchant['name']).to eq(merchants[1].name)

    get api_v1_merchants_find_path(merchant: {created_at: merchants[2].created_at})
    merchant = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(merchant['name']).to eq(merchants[2].name)

    get api_v1_merchants_find_path(merchant: {updated_at: merchants[0].updated_at})
    merchant = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(merchant['name']).to eq(merchants[0].name)
  end
end
