class TrimesterDatabase
  attr_reader :trimesters
  private_class_method :new

  def load
    @trimesters = Dir.glob('db/courses/*.json').collect do |trimester_json|
      trimester_slug = File.basename(trimester_json, '.json')
      file_content = File.open(trimester_json).read
      serialized_bachelors = JSON.parse(file_content)
      TrimesterBuilder.build(trimester_slug, serialized_bachelors)
    end
  end

  class << self
    def instance
      @instance ||= new
    end
  end
end