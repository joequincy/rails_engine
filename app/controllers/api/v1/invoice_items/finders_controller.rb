class Api::V1::InvoiceItems::FindersController < ApplicationController
  include FindersModule
  include Currency

  private

  def strong_params
    ensure_cents
    params.permit([:item_id, :invoice_id, :quantity, :unit_price] + universal_params)
  end
end
