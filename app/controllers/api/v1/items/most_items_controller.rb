class Api::V1::Items::MostItemsController < ApplicationController
  def index
    query = Item.by_most_sold(params[:quantity])

    render json: ItemSerializer.new(query)
  end
end
