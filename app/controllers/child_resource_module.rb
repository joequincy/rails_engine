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

  def name(reflection)
    reflection.name.to_s.classify.constantize
  end
end
