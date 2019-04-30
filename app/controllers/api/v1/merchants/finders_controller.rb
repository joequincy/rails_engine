class Api::V1::Merchants::FindersController < Api::V1::MerchantsController
  def show
    render json: serialize(Merchant.find_by(merchant_params))
  end

  private

  def merchant_params
    params.require(:merchant).permit([:id, :name, :created_at, :updated_at])
  end
end
