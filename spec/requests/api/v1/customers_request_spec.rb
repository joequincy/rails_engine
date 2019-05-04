require 'rails_helper'

describe 'Customers API Record Endpoints' do
  it 'sends a list of customers' do
    create_list(:customer, 3)
    get api_v1_customers_path

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers['data'].count).to eq(3)
  end

  it 'can get one customer by its id' do
    id = create(:customer).id
    get api_v1_customer_path(id)

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer['data']['id'].to_i).to eq(id)
  end

  it 'can get a random customer' do
    customers = create_list(:customer, 10)

    get api_v1_customers_random_path

    customer = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    record = Customer.find(customer['id'])
    expect(customer['first_name']).to eq(record.first_name)
    expect(customer['last_name']).to eq(record.last_name)
  end

  it 'can find one customer by its attributes' do
    customers = create_list(:customer, 3)
    get api_v1_customers_find_path(id: customers[0].id)
    customer = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(customer['first_name']).to eq(customers[0].first_name)

    get api_v1_customers_find_path(first_name: customers[1].first_name)
    customer = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(customer['first_name']).to eq(customers[1].first_name)

    get api_v1_customers_find_path(created_at: customers[2].created_at)
    customer = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(customer['first_name']).to eq(customers[2].first_name)

    get api_v1_customers_find_path(updated_at: customers[0].updated_at)
    customer = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(customer['first_name']).to eq(customers[0].first_name)
  end

  it 'can find multiple customers by their attributes' do
    customers = create_list(:customer, 3, first_name: 'SameName')
    get api_v1_customers_find_all_path(id: customers[0].id)
    customer_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(customer_list.count).to eq(1)
    expect(customer_list.first['attributes']['first_name']).to eq(customers[0].first_name)

    get api_v1_customers_find_all_path(first_name: customers[1].first_name)
    customer_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(customer_list.count).to eq(3)
    expect(customer_list.first['attributes']['first_name']).to eq(customers[1].first_name)

    get api_v1_customers_find_all_path(created_at: customers[2].created_at)
    customer_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(customer_list.first['attributes']['first_name']).to eq(customers[2].first_name)

    get api_v1_customers_find_all_path(updated_at: customers[0].updated_at)
    customer_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(customer_list.first['attributes']['first_name']).to eq(customers[0].first_name)
  end
end
