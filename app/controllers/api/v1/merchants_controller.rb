class Api::V1::MerchantsController < ApplicationController
  def index
    render json: serialize(Merchant.all)
  end

  def show
    render json: serialize(Merchant.find(params[:id]))
  end

  private

  def serialize(obj)
    MerchantSerializer.new(obj)
  end
end
