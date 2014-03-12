class Week
  class << self
    def workdays
      Weekday.all.first(5)
    end

    def weekend
      Weekday.all.last(2)
    end

    def first(to = 1)
      Weekday.all.first(to)
    end

    def last(i = 1)
      Weekday.all.last(i)
    end

    def [](i)
      Weekday.all[i]
    end
  end
end