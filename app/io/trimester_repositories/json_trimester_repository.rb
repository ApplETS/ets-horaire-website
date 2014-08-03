class JsonTrimesterRepository
  def initialize(folder = nil)
    @folder = folder || default_folder
    @last_modified_timestamp = 0
  end

  def fetch_trimesters
    Dir.glob(folder_appended_with('*.json')).collect do |trimester_json|
      trimester_slug = File.basename(trimester_json, '.json')
      file_content = File.open(trimester_json).read
      serialized_bachelors = JSON.parse(file_content)
      TrimesterBuilder.build(trimester_slug, serialized_bachelors)
    end
  end

  def reload?
    file_timestamp = read_last_modified_file
    return false if @last_modified_timestamp == file_timestamp

    @last_modified_timestamp = file_timestamp
    true
  end

  private

  def default_folder
    Rails.root.join('db/courses', Rails.env)
  end

  def read_last_modified_file
    folder = folder_appended_with('last_modified_timestamp')
    timestamp = File.open(folder, 'r').read
    Integer(timestamp)
  end

  def folder_appended_with(file)
    Rails.root.join @folder, file
  end
end