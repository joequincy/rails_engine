class ApplicationController < ActionController::API
  # All models use the exact same query (with their respective
  # model names and serializers) for their index and show outputs
  # so creating generic versions here allows me to create
  # fully functional controllers for new models just by delclaring
  # an empty class and inheriting from here
  def index
    render json: serializer.new(model.all.load)
  end

  def show
    render json: serializer.new(model.find(params[:id]))
  end

  private

  def universal_params
    # These will be needed in every 'strong_params'
    [:id, :created_at, :updated_at]
  end

  def model
    # For controllers that do not have modules overriding this behavior
    # Gets the ____Controller portion of the current class name from
    # a namespaced class, removes the "Controller" from the end, and
    # gets the singular form to get the model name. Then converts to
    # constant so it can point to the class for that model.
    @model ||= self.class
                   .name
                   .demodulize
                   .sub(/Controller$/,"")
                   .singularize
                   .constantize
  end

  def serializer
    # Takes the model constant found above, and appends "Serializer"
    @serializer ||= "#{model.to_s}Serializer".constantize
  end
end
