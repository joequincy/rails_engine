class Api::V1::Items::FindersController < ApplicationController
  include FindersModule
  include Currency

  private

  def strong_params
    ensure_cents
    params.permit([:name, :description, :unit_price, :merchant_id] + universal_params)
  end
end
