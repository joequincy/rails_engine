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
    @model ||= self.class
                   .name
                   .deconstantize
                   .demodulize
                   .singularize
                   .constantize
  end
end
