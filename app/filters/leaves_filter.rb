class LeavesFilter
  def self.valid?(group, leaves)
    group.periods.all? do |period|
      leaves.none? do |leave|
        leave.conflicts?(period)
      end
    end
  end
end