class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    query = Merchant.top_by_items(params[:quantity])

    render json: MerchantSerializer.new(query)
  end
end
