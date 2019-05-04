module RandomModule
  def show
    table = model.name.pluralize.underscore
    selection = model.find_by_sql("SELECT * FROM #{table}
                               OFFSET random() * (SELECT COUNT(*) FROM #{table})
                               LIMIT 1").first

    render json: serializer.new(selection)
  end

  private

  def model
    # This will execute in a RandomController namespaced under the plural
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
