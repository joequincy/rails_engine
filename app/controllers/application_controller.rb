class ApplicationController < ActionController::API
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
