# -*- encoding : utf-8 -*-

class AsciiCalendarController < ApplicationController
  before_filter :ensure_key_present
  before_filter :ensure_key_valid

  def index
    render text: AsciiCalendarPrinter.new.output(@schedules)
  end

  private

  def ensure_key_present
    return if params.has_key?(:cle)
    redirect_to root_path
  end

  def ensure_key_valid
    data = Rails.cache.read(params[:cle])
    return flash_invalid_key if data.nil?

    @results_data = JSON.parse(data)
    @schedules = Deserialize.schedules_from(@results_data['serialized_schedules'])
  end

  def flash_invalid_key
    flash[:notice] = "Votre clé n'est plus valide!"
    redirect_to root_path
  end
end