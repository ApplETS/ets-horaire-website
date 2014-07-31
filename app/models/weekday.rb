# -*- encoding : utf-8 -*-

class Weekday
  include Serializable

  LANGUAGES = {
    EN: %w(monday tuesday wednesday thursday friday saturday sunday),
    FR: %w(lundi mardi mercredi jeudi vendredi samedi dimanche)
  }

  attr_reader :index

  def initialize(index)
    @index = index
  end

  LANGUAGES.keys.each do |lang|
    lang_downcase = lang.downcase
    short_lang_downcase = "short_#{lang_downcase}".to_sym

    define_singleton_method(lang_downcase) do |name|
      create_weekday_using(lang, name) { |weekday| weekday == name.downcase }
    end

    define_singleton_method(short_lang_downcase) do |name|
      create_weekday_using(lang, name) { |weekday| weekday[0..2] == name.downcase }
    end

    define_method(lang_downcase) { LANGUAGES[lang][@index] }
  end

  def workday?
    (0..4).include?(@index)
  end

  def weekend?
    (5..6).include?(@index)
  end

  def ==(c)
    @index == c.index
  end

  class << self
    def all
      (0..6).collect { |index| new index }
    end

    private

    def create_weekday_using(lang, name, &block)
      index = LANGUAGES[lang].index(&block)
      raise "'#{name}' is not a valid weekday." if index.nil?
      Weekday.new index
    end
  end

end
