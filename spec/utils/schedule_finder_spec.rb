# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ScheduleFinder do

  describe "when finding combinations of possible courses" do
    NB_COURSES = 5
    NB_COURSES.times.each do |courses_per_schedule|
      describe "when providing no courses" do
        subject { ScheduleFinder.build }

        let(:schedules) { subject.combinations_for [], courses_per_schedule }

        it "should not find any possible schedules" do
          schedules.should be_empty
        end
      end
    end

    describe "when providing a single course" do
      subject { ScheduleFinder.build }

      let(:period_1_5) { Period.new(Weekday.en("friday"), "Cours", WeekdayTime.new(Weekday.en("friday"), 6, 00), WeekdayTime.new(Weekday.en("friday"), 7, 00)) }
      let(:group_5) { Group.new(5, [period_1_5]) }

      let(:group_7) { Group.new(7, []) }

      let(:period_1_8) { Period.new(Weekday.en("monday"), "Cours", WeekdayTime.new(Weekday.en("monday"), 6, 00), WeekdayTime.new(Weekday.en("monday"), 7, 00)) }
      let(:period_2_8) { Period.new(Weekday.en("monday"), "TP", WeekdayTime.new(Weekday.en("monday"), 9, 00), WeekdayTime.new(Weekday.en("monday"), 10, 00)) }
      let(:group_8) { Group.new(8, [period_1_8, period_2_8]) }

      let(:course) { Course.new("LOG550", [group_5, group_7, group_8]) }
      let(:courses) { [course] }

      describe "when specifying 0 courses per schedule" do
        let(:schedules) { subject.combinations_for courses, 0 }

        it "should not find any possible schedule" do
          schedules.should be_empty
        end
      end

      describe "when specifying 1 course per schedule" do
        let(:schedules) { subject.combinations_for courses, 1 }

        it "should find three possible schedules" do
          schedules.should have_exactly(3).items
        end

        it "should have one period per schedule" do
          schedules.each { |groups| groups.should have_exactly(1).item }
        end

        it "should have the period in the schedules with LOG550 as the course name" do
          schedules.each { |groups| groups.first.course_name.should == "LOG550" }
        end

        it "should find one possible schedule with group 5" do
          schedules.should conceptually_include(group_5)
        end

        it "should find one possible schedule with group 7" do
          schedules.should conceptually_include(group_7)
        end

        it "should find one possible schedule with group 8" do
          schedules.should conceptually_include(group_8)
        end
      end

      describe "when specifying 2 courses per schedule" do
        let(:schedules) { subject.combinations_for courses, 2 }

        it "should not find any possible schedule" do
          schedules.should be_empty
        end
      end
    end

    describe "when providing multiple courses" do
      # COM110
      let(:period_1_1_1) { Period.new(Weekday.en("thursday"), "Cours", WeekdayTime.new(Weekday.en("thursday"), 9, 00), WeekdayTime.new(Weekday.en("thursday"), 12, 30)) }
      let(:period_2_1_1) { Period.new(Weekday.en("tuesday"), "TP", WeekdayTime.new(Weekday.en("tuesday"), 8, 30), WeekdayTime.new(Weekday.en("tuesday"), 12, 30)) }
      let(:group_1_1) { Group.new(1, [period_1_1_1, period_2_1_1]) }

      let(:period_1_2_1) { Period.new(Weekday.en("wednesday"), "Cours", WeekdayTime.new(Weekday.en("wednesday"), 9, 00), WeekdayTime.new(Weekday.en("wednesday"), 12, 30)) }
      let(:period_2_2_1) { Period.new(Weekday.en("monday"), "TP", WeekdayTime.new(Weekday.en("monday"), 8, 30), WeekdayTime.new(Weekday.en("monday"), 12, 30)) }
      let(:group_2_1) { Group.new(2, [period_1_2_1, period_2_2_1]) }

      let(:period_1_3_1) { Period.new(Weekday.en("monday"), "Cours", WeekdayTime.new(Weekday.en("monday"), 18, 00), WeekdayTime.new(Weekday.en("monday"), 21, 30)) }
      let(:period_2_3_1) { Period.new(Weekday.en("wednesday"), "TP", WeekdayTime.new(Weekday.en("wednesday"), 18, 00), WeekdayTime.new(Weekday.en("wednesday"), 22, 00)) }
      let(:group_3_1) { Group.new(3, [period_1_3_1, period_2_3_1]) }

      let(:period_1_4_1) { Period.new(Weekday.en("wednesday"), "Cours", WeekdayTime.new(Weekday.en("wednesday"), 13, 30), WeekdayTime.new(Weekday.en("wednesday"), 17, 00)) }
      let(:period_2_4_1) { Period.new(Weekday.en("friday"), "TP", WeekdayTime.new(Weekday.en("friday"), 8, 30), WeekdayTime.new(Weekday.en("friday"), 12, 30)) }
      let(:group_4_1) { Group.new(4, [period_1_4_1, period_2_4_1]) }

      let(:period_1_5_1) { Period.new(Weekday.en("thursday"), "Cours", WeekdayTime.new(Weekday.en("thursday"), 18, 00), WeekdayTime.new(Weekday.en("thursday"), 21, 30)) }
      let(:period_2_5_1) { Period.new(Weekday.en("tuesday"), "TP", WeekdayTime.new(Weekday.en("tuesday"), 18, 00), WeekdayTime.new(Weekday.en("tuesday"), 22, 00)) }
      let(:group_5_1) { Group.new(5, [period_1_5_1, period_2_5_1]) }

      let(:course_1) { Course.new("COM110", [group_1_1, group_2_1, group_3_1, group_4_1, group_5_1]) }

      # LOG320
      let(:period_1_1_2) { Period.new(Weekday.en("friday"), "Cours", WeekdayTime.new(Weekday.en("friday"), 13, 00), WeekdayTime.new(Weekday.en("friday"), 17, 00)) }
      let(:period_2_1_2) { Period.new(Weekday.en("tuesday"), "TP", WeekdayTime.new(Weekday.en("tuesday"), 13, 00), WeekdayTime.new(Weekday.en("tuesday"), 17, 00)) }
      let(:group_1_2) { Group.new(1, [period_1_1_2, period_2_1_2]) }

      let(:course_2) { Course.new("LOG320", [group_1_2]) }

      # LOG330
      let(:period_1_1_3) { Period.new(Weekday.en("thursday"), "Cours", WeekdayTime.new(Weekday.en("thursday"), 18, 00), WeekdayTime.new(Weekday.en("thursday"), 21, 00)) }
      let(:period_2_1_3) { Period.new(Weekday.en("friday"), "TP", WeekdayTime.new(Weekday.en("friday"), 18, 00), WeekdayTime.new(Weekday.en("friday"), 20, 00)) }
      let(:group_1_3) { Group.new(1, [period_1_1_3, period_2_1_3]) }

      let(:period_1_2_3) { Period.new(Weekday.en("monday"), "Cours", WeekdayTime.new(Weekday.en("monday"), 18, 00), WeekdayTime.new(Weekday.en("monday"), 21, 00)) }
      let(:period_2_2_3) { Period.new(Weekday.en("tuesday"), "TP", WeekdayTime.new(Weekday.en("tuesday"), 9, 00), WeekdayTime.new(Weekday.en("tuesday"), 12, 00)) }
      let(:group_2_3) { Group.new(2, [period_1_2_3, period_2_2_3]) }

      let(:course_3) { Course.new("LOG330", [group_1_3, group_2_3]) }

      # GIA400
      let(:period_1_1_4) { Period.new(Weekday.en("tuesday"), "Cours", WeekdayTime.new(Weekday.en("tuesday"), 18, 00), WeekdayTime.new(Weekday.en("tuesday"), 21, 00)) }
      let(:period_2_1_4) { Period.new(Weekday.en("friday"), "TP", WeekdayTime.new(Weekday.en("friday"), 9, 00), WeekdayTime.new(Weekday.en("friday"), 12, 00)) }
      let(:group_1_4) { Group.new(1, [period_1_1_4, period_2_1_4]) }

      let(:period_1_2_4) { Period.new(Weekday.en("friday"), "Cours", WeekdayTime.new(Weekday.en("friday"), 13, 00), WeekdayTime.new(Weekday.en("friday"), 17, 00)) }
      let(:period_2_2_4) { Period.new(Weekday.en("monday"), "TP", WeekdayTime.new(Weekday.en("monday"), 13, 00), WeekdayTime.new(Weekday.en("monday"), 17, 00)) }
      let(:group_2_4) { Group.new(2, [period_1_2_4, period_2_2_4]) }

      let(:period_1_3_4) { Period.new(Weekday.en("wednesday"), "Cours", WeekdayTime.new(Weekday.en("wednesday"), 9, 00), WeekdayTime.new(Weekday.en("wednesday"), 12, 00)) }
      let(:period_2_3_4) { Period.new(Weekday.en("monday"), "TP", WeekdayTime.new(Weekday.en("monday"), 9, 00), WeekdayTime.new(Weekday.en("monday"), 12, 00)) }
      let(:group_3_4) { Group.new(3, [period_1_3_4, period_2_3_4]) }

      let(:course_4) { Course.new("GIA400", [group_1_4, group_2_4, group_3_4]) }

      describe 'with no additional filters' do
        subject { ScheduleFinder.build }

        context 'for a possiblity of 0' do
          let(:courses) { [course_1, course_2, course_3, course_4] }
          let(:schedules) { subject.combinations_for courses, 0 }

          it 'should find no possibilities' do
            schedules.should be_empty
          end
        end

        context 'when specifying 3 courses per schedule' do
          context 'with a possibility of 2' do
            let(:courses) { [course_2, course_3, course_4] }
            let(:schedules) { subject.combinations_for courses, 2 }

            it 'should find all 9 possibilities' do
              schedules.should have_exactly(10).items

              schedules.should conceptually_include(group_1_2, group_1_3)
              schedules.should conceptually_include(group_1_2, group_2_3)
              schedules.should conceptually_include(group_1_2, group_1_4)
              schedules.should conceptually_include(group_1_2, group_3_4)
              schedules.should conceptually_include(group_1_3, group_1_4)
              schedules.should conceptually_include(group_1_3, group_2_4)
              schedules.should conceptually_include(group_1_3, group_3_4)
              schedules.should conceptually_include(group_2_3, group_1_4)
              schedules.should conceptually_include(group_2_3, group_2_4)
              schedules.should conceptually_include(group_2_3, group_3_4)
            end
          end

          context 'with a possibility of 3' do
            let(:courses) { [course_2, course_3, course_4] }
            let(:schedules) { subject.combinations_for courses, 3 }

            it 'should find all 4 possibilities' do
              schedules.should have_exactly(4).items

              schedules.should conceptually_include(group_1_2, group_1_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_1_3, group_3_4)
              schedules.should conceptually_include(group_1_2, group_2_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_2_3, group_3_4)
            end
          end
        end

        context 'for 4 courses' do
          let(:courses) { [course_1, course_2, course_3, course_4] }

          context 'for a possiblity of 1' do
            let(:schedules) { subject.combinations_for courses, 1 }

            it 'should find all 11 possibilities' do
              schedules.should have_exactly(11).items

              schedules.should conceptually_include(group_1_1)
              schedules.should conceptually_include(group_2_1)
              schedules.should conceptually_include(group_3_1)
              schedules.should conceptually_include(group_4_1)
              schedules.should conceptually_include(group_5_1)
              schedules.should conceptually_include(group_1_2)
              schedules.should conceptually_include(group_1_3)
              schedules.should conceptually_include(group_2_3)
              schedules.should conceptually_include(group_1_4)
              schedules.should conceptually_include(group_2_4)
              schedules.should conceptually_include(group_3_4)
            end
          end

          context 'for a possiblity of 4' do
            let(:schedules) { subject.combinations_for courses, 4 }

            it 'should find all 9 possibilities' do
              schedules.should have_exactly(9).items

              schedules.should conceptually_include(group_1_2, group_1_1, group_1_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_1_1, group_1_3, group_3_4)
              schedules.should conceptually_include(group_1_2, group_2_1, group_1_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_2_1, group_2_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_3_1, group_1_3, group_1_4)
              schedules.should conceptually_include(group_1_2, group_3_1, group_1_3, group_3_4)
              schedules.should conceptually_include(group_1_2, group_4_1, group_1_3, group_3_4)
              schedules.should conceptually_include(group_1_2, group_4_1, group_2_3, group_3_4)
              schedules.should conceptually_include(group_1_2, group_5_1, group_2_3, group_3_4)
            end
          end

          context 'for a possiblity of 5' do
            let(:schedules) { subject.combinations_for courses, 5 }

            it 'should find all 9 possibilities' do
              schedules.should be_empty
            end
          end
        end
      end

      describe 'when applying a additional comparator' do
        let(:courses) { [course_1, course_2, course_3, course_4] }

        describe 'with a comparator that always returns false' do
          subject do
            ScheduleFinder.build do |c|
              c.additional_comparator { false }
            end
          end

          it { expect(subject.combinations_for(courses, 4)).to be_empty }
        end

        describe 'when group with number 3 are filtered out' do
          subject do
            ScheduleFinder.build do |c|
              c.additional_comparator do |groups_combinations, group|
                group.nb != 3
              end
            end
          end
          let(:schedules) { subject.combinations_for courses, 4 }

          it "should not have any mentions of groups with number 3" do
            schedules.should have_exactly(3).items

            schedules.should conceptually_include(group_1_2, group_1_1, group_1_3, group_1_4)
            schedules.should conceptually_include(group_1_2, group_2_1, group_1_3, group_1_4)
            schedules.should conceptually_include(group_1_2, group_2_1, group_2_3, group_1_4)
          end
        end
      end
    end
  end
end