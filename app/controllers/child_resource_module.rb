module ChildResourceModule
  def index
    render json: serializer.new(query)
  end

  def show
    render json: serializer.new(query.first)
  end

  private

  def query
    model.joins(build_joins)
         .select("#{model.name.underscore.pluralize}.*")
         .where("#{parent_model.name.underscore.pluralize}.id" => params[parent_model.name.foreign_key])
  end

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

  def build_joins
    reflections = {}
    model.reflect_on_all_associations.each do |reflection|
      case reflection.class.name.demodulize
      when "BelongsToReflection"
        reflections[name(reflection)] = reflection.name
      when "HasManyReflection"
        reflections[name(reflection)] = reflection.name
      when "ThroughReflection"
        delegate = reflection.delegate_reflection
        reflections[name(delegate)] = {delegate.options[:through] => reflection.source_reflection_name}
      end
    end
    reflections[parent_model]
  end

  def name(reflection)
    reflection.name.to_s.classify.constantize
  end
end
