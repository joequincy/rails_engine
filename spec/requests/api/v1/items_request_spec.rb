require 'rails_helper'

describe 'Items API Record Endpoints' do
  it 'sends a list of items' do
    create_list(:item, 3)
    get api_v1_items_path

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items['data'].count).to eq(3)
  end

  it 'can get one item by its id' do
    id = create(:item).id
    get api_v1_item_path(id)

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item['data']['id'].to_i).to eq(id)
  end

  it 'can find one item by its attributes' do
    items = create_list(:item, 3)
    get api_v1_items_find_path(id: items[0].id)
    item = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(item['name']).to eq(items[0].name)

    get api_v1_items_find_path(name: items[1].name)
    item = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(item['name']).to eq(items[1].name)
  end

  it 'can find multiple items by their attributes' do
    items = create_list(:item, 3, name: 'SameName')
    get api_v1_items_find_all_path(id: items[0].id)
    item_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(item_list.count).to eq(1)
    expect(item_list.first['attributes']['name']).to eq(items[0].name)

    get api_v1_items_find_all_path(name: items[1].name)
    item_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(item_list.count).to eq(3)
    expect(item_list.first['attributes']['name']).to eq(items[1].name)
  end
end
