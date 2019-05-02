class Api::V1::Invoices::FindersController < ApplicationController
  include FindersModule

  private

  def strong_params
    params.permit([:customer_id, :merchant_id, :status] + universal_params)
  end
end
