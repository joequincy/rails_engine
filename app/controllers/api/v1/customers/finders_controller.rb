class Api::V1::Customers::FindersController < ApplicationController
  include FindersModule

  private

  def strong_params
    params.permit([:first_name, :last_name] + universal_params)
  end
end
