class Api::V1::Merchants::MostRevenuesController < ApplicationController
  def index
    if params[:quantity]
      query = Merchant.top_by_revenue(params[:quantity])

      render json: MerchantSerializer.new(query)
    elsif params[:date]
      query = Merchant.date_revenue(params[:date]) if params[:date]

      render json: AnalysisSerializer.new(query, fields: {analysis: [:total_revenue]})
    end
  end
end
