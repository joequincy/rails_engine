module FindersModule
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
