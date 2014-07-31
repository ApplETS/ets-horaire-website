class Serializer
  class << self
    def inherited(child)
      child.class_variable_set(:'@@attributes', {})
      child.class_variable_set(:'@@deserialization_order', [])
    end

    def attribute(name, type = nil)
      attributes = self.class_variable_get(:'@@attributes')
      attributes[name] = Attribute.new(name, type)
      self.class_variable_set(:'@@attributes', attributes)
    end

    def deserialization_order(*attribute_names)
      self.class_variable_set(:'@@deserialization_order', attribute_names)
    end

    def deserialize(model, data)
      attributes = self.class_variable_get(:'@@attributes')

      instance_attributes = fetch_deserialization_order.collect do |attribute_name|
        attribute = attributes.fetch(attribute_name)
        attribute.deserialize_using(data)
      end
      model.new(*instance_attributes)
    end

    private

    def fetch_deserialization_order
      deserialization_order = self.class_variable_get(:'@@deserialization_order')
      deserialization_order.empty? ? self.class_variable_get(:'@@attributes').keys : deserialization_order
    end
  end

  def initialize(model)
    @model = model
  end

  def method_missing(method_name, *arguments, &block)
    if @model.respond_to?(method_name)
      @model.send(method_name, *arguments, &block)
    else
      super
    end
  end

  def respond_to?(method_name, include_private = false)
    @model.respond_to?(method_name, include_private)
  end

  def serialize
    output = {}
    attributes.values.each do |attribute|
      output[attribute.name] = attribute.serialize_using(@model)
    end
    output
  end

  private

  def attributes
    self.class.class_variable_get(:'@@attributes')
  end

  class Attribute
    attr_accessor :name, :type

    def initialize(name, type = nil)
      @name = name
      @type = type
    end

    def serialize_using(model)
      attribute = model.send(@name)
      serialized_value_of(attribute)
    end

    def deserialize_using(data)
      value = data.fetch(name.to_s)
      deserialized_value_of(value)
    end

    private

    def serialized_value_of(attribute)
      if attribute.is_a?(Array)
        attribute.collect { |x| serialized_value_of(x) }
      else
        attribute.respond_to?(:serialize) ? attribute.serialize : attribute
      end
    end

    def deserialized_value_of(value)
      if value.is_a?(Array)
        value.collect { |x| deserialized_value_of(x) }
      else
        return value if @type.nil?
        has_serializer? ? @type.deserialize(value) : @type.new(value)
      end
    end

    def has_serializer?
      defined?("#{@type.name}Serializer")
    end
  end
end