module Serializable
  extend ActiveSupport::Concern

  def serialize
    serializer_name = "#{self.class.name}Serializer"
    serializer_class = serializer_name.constantize
    serializer_class.new(self).serialize
  end

  module ClassMethods
    def deserialize(data)
      serializer_name = "#{self.name}Serializer"
      serializer_class = serializer_name.constantize
      serializer_class.deserialize(self, data)
    end
  end
end