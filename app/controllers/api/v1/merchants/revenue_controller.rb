class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    query = Merchant.merchant_revenue(params[:merchant_id], params[:date])

    render json: AnalysisSerializer.new(query, fields: {analysis: [:revenue]})
  end
end
