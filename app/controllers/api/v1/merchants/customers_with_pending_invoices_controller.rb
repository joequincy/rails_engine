class Api::V1::Merchants::CustomersWithPendingInvoicesController < ApplicationController
  def index
    query = Customer.in_debt_to(params[:merchant_id])

    render json: CustomerSerializer.new(query)
  end
end
