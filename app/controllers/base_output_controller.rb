# -*- encoding : utf-8 -*-

class BaseOutputController < ApplicationController
  before_filter :ensure_key_present
  before_filter :ensure_key_valid

  def index
    printer = Printer.find_by_slug(params[:controller])
    render text: printer.output(@schedules)
  end

  private

  def ensure_key_present
    return if params.has_key?(:cle)
    redirect_to root_path
  end

  def ensure_key_valid
    @results_data = Rails.cache.read(params[:cle])
    return flash_invalid_key if @results_data.nil?

    @schedules = @results_data.schedules
  end

  def flash_invalid_key
    flash[:notice] = "Votre clé n'est plus valide!"
    redirect_to root_path
  end
end