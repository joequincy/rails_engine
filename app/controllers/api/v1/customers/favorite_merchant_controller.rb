class Api::V1::Customers::FavoriteMerchantController < ApplicationController
  def show
    query = Merchant.customer_favorite(params[:customer_id])

    render json: MerchantSerializer.new(query)
  end
end
