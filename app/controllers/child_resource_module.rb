module ChildResourceModule
  private

  def model
    @model ||= self.class
                   .name
                   .demodulize
                   .sub(/Controller$/,"")
                   .singularize
                   .constantize
  end

  def parent_model
    @parent_model ||= self.class
                          .name
                          .deconstantize
                          .demodulize
                          .singularize
                          .constantize
  end
end
