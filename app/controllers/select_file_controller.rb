# encoding: UTF-8

class SelectFileController < ApplicationController
  def index
    @trimesters = TrimesterDatabase.instance.sorted
  end

  def choose
    redirect_to schedule_path(trimester: params[:trimester])
  end
end