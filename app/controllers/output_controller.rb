# encoding: UTF-8

class OutputController < ApplicationController
  def index
    @outputs = Printer.all
  end
end