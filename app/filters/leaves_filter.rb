class LeavesFilter
  class << self
    def scan(group, leaves)
      group.periods.all? do |period|
        leaves.none? do |leave|
          leave.conflicts?(period)
        end
      end
    end
  end
end