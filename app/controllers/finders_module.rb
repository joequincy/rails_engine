module FindersModule
  def index
    render json: serializer.new(model.order(id: :asc)
                                     .where(strong_params))
  end

  def show
    render json: serializer.new(model.order(id: :asc)
                                     .find_by(strong_params))
  end

  private

  def model
    # This will execute in a FindersController namespaced under the plural
    # form of the current model. Uses inflectors to get the constant
    # referring to that model.
    @model ||= self.class
                   .name
                   .deconstantize
                   .demodulize
                   .singularize
                   .constantize
  end
end
