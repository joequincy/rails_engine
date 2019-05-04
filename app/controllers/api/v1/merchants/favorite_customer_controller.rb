class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def show
    query = Customer.merchant_favorite(params[:merchant_id])

    render json: CustomerSerializer.new(query)
  end
end
