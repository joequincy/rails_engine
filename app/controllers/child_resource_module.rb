module ChildResourceModule
  def index
    render json: serializer.new(query)
  end

  def show
    render json: serializer.new(query.first)
  end

  private

  def query
    # Both index and show need this query.
    # The first part of the WHERE clause converts the parent model to its
    # table's name.
    # The second part grabs the appropriate foreign key from the params hash.
    # This requires appropriate routes to use the foreign key instead if ':id'.
    model.joins(build_joins)
         .where("#{parent_model.name.underscore.pluralize}.id":
                   params[parent_model.name.foreign_key])
         .order(:id)
  end

  def parent_model
    # This will execute in a controller namespaced under the plural
    # form of the parent model. Uses inflectors to get the constant
    # referring to that model.
    @parent_model ||= self.class
                          .name
                          .deconstantize
                          .demodulize
                          .singularize
                          .constantize
  end

  def build_joins
    # Looks at all associations on the current model, and stores the
    # arguments (needed by the .joins() method in order to join from
    # the current model to that association) into a hash using the
    # association model's constant as a key. Then returns the value
    # associated with the parent model's constant.
    reflections = {}
    model.reflect_on_all_associations.each do |reflection|
      case reflection.class.name.demodulize
      when "BelongsToReflection"
        reflections[name(reflection)] = reflection.name
      when "HasManyReflection"
        reflections[name(reflection)] = reflection.name
      when "ThroughReflection"
        delegate = reflection.delegate_reflection
        # For associations that pass through another table, use the hash
        # notation. Ensures proper pluralization by using
        # .delegate_reflection.options[:through] #=> for the join table, and
        # .source_reflection_name #=> for the association
        reflections[name(delegate)] = {delegate.options[:through] => reflection.source_reflection_name}
      end
    end
    reflections[parent_model]
  end

  def name(reflection)
    # get the model name assoicated with a reflection and return its constant
    reflection.name.to_s.classify.constantize
  end
end
