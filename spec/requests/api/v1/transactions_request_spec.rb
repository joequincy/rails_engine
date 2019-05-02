require 'rails_helper'

describe 'Transactions API Record Endpoints' do
  it 'sends a list of transactions' do
    create_list(:transaction, 3)
    get api_v1_transactions_path

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions['data'].count).to eq(3)
  end

  it 'can get one transaction by its id' do
    id = create(:transaction).id
    get api_v1_transaction_path(id)

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction['data']['id'].to_i).to eq(id)
  end

  it 'can find one transaction by its attributes' do
    transactions = create_list(:transaction, 3)
    get api_v1_transactions_find_path(id: transactions[0].id)
    transaction = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(transaction['credit_card_number']).to eq(transactions[0].credit_card_number)

    get api_v1_transactions_find_path(credit_card_number: transactions[1].credit_card_number)
    transaction = JSON.parse(response.body)['data']['attributes']

    expect(response).to be_successful
    expect(transaction['credit_card_number']).to eq(transactions[1].credit_card_number)
  end

  it 'can find multiple transactions by their attributes' do
    transactions = create_list(:transaction, 3, credit_card_number: '4324012933219942')
    get api_v1_transactions_find_all_path(id: transactions[0].id)
    transaction_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(transaction_list.count).to eq(1)
    expect(transaction_list.first['attributes']['credit_card_number']).to eq(transactions[0].credit_card_number)

    get api_v1_transactions_find_all_path(credit_card_number: transactions[1].credit_card_number)
    transaction_list = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(transaction_list.count).to eq(3)
    expect(transaction_list.first['attributes']['credit_card_number']).to eq(transactions[1].credit_card_number)
  end
end
