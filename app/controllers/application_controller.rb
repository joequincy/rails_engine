class ApplicationController < ActionController::API
  def model
    @model ||= self.class
                   .name
                   .demodulize
                   .sub(/Controller$/,"")
                   .singularize
                   .constantize
  end
end
