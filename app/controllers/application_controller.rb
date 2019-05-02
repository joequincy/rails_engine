class ApplicationController < ActionController::API
  def index
    render json: serializer.new(model.all.load)
  end

  def show
    render json: serializer.new(model.find(params[:id]))
  end

  private

  def universal_params
    [:id, :created_at, :updated_at]
  end

  def model
    @model ||= self.class
                   .name
                   .demodulize
                   .sub(/Controller$/,"")
                   .singularize
                   .constantize
  end

  def serializer
    @serializer ||= "#{model.to_s}Serializer".constantize
  end
end
