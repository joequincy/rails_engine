class Api::V1::Items::BestDayController < ApplicationController
  def show
    query = Item.best_day(params[:item_id])

    render json: AnalysisSerializer.new(query, fields: {analysis: [:best_day]})
  end
end
