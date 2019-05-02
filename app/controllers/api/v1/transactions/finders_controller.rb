class Api::V1::Transactions::FindersController < ApplicationController
  include FindersModule

  private

  def strong_params
    params.permit([:invoice_id, :credit_card_number, :result] + universal_params)
  end
end
