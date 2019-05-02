class Api::V1::Merchants::FindersController < ApplicationController
  include FindersModule

  private

  def strong_params
    params.permit([:name] + universal_params)
  end
end
