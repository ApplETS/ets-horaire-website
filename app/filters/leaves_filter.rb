class LeavesFilter
  def self.keep?(course, leaves)
    return true if leaves.empty?

    course.periods.all? do |period|
      leaves.none? do |leave|
        leave.conflicts?(period)
      end
    end
  end
end