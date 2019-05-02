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
end
