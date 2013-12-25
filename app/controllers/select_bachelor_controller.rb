class SelectBachelorController < ApplicationController
  def index
    @trimesters = TrimesterDatabase.instance.sorted
  end
end