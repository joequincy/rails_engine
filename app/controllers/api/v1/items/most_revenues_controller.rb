class Api::V1::Items::MostRevenuesController < ApplicationController
  def index
    query = Item.by_most_revenue(params[:quantity])

    render json: ItemSerializer.new(query)
  end
end
