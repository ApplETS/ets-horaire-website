# -*- encoding : utf-8 -*-

class Group
  include Serializable

  attr_reader :nb, :periods

  def initialize(nb, periods)
    @nb = nb
    @periods = periods
  end

  def conflicts?(group)
    periods.any? do |period|
      group.periods.any? { |comparable_period| period.conflicts?(comparable_period) }
    end
  end
end
