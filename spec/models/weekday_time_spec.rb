# -*- encoding : utf-8 -*-
require 'spec_helper'

describe WeekdayTime do
  describe "When creating a weekday time on tuesday at 14:35 (2:35 pm)" do
    let(:time) { WeekdayTime.new(14, 35) }

    specify { time.to_s.should == "14h35" }
    specify { time.hour.should == 14 }
    specify { time.minutes.should == 35 }
    specify { time.to_i.should == 875 }
  end
end
