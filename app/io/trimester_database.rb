class TrimesterDatabase
  class << self
    attr_accessor :repository

    def instance
      @instance ||= new(@repository)
      @instance.reload if @repository.reload?
      @instance
    end
  end

  private_class_method :new
  def initialize(repository)
    @repository = repository
  end

  def reload
    @trimesters = @repository.fetch_trimesters
    @sorted_trimesters = SortTrimesters.by_terms_then_year(@trimesters)
  end

  def all
    @trimesters
  end

  def sorted
    @sorted_trimesters
  end
end