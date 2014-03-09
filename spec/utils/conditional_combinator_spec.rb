# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConditionalCombinator do

  describe "when providing an always true condition" do
    subject do
      ConditionalCombinator.build do |c|
        c.comparator { true }
      end
    end

    describe "when finding combinations of 4" do
      let(:combinations) { subject.find_combinations([1, 2, 3, 4, 5, 6], 4) }

      it "should find all possible combinations" do
        combinations.should match_arrays([1, 2, 3, 4], [1, 2, 3, 5], [1, 2, 3, 6], [1, 2, 4, 5], [1, 2, 4, 6], [1, 2, 5, 6], [1, 3, 4, 5], [1, 3, 4, 6], [1, 3, 5, 6], [1, 4, 5, 6], [2, 3, 4, 5], [2, 3, 4, 6], [2, 3, 5, 6], [2, 4, 5, 6], [3, 4, 5, 6])
      end
    end

    describe "when finding combinations of 2" do
      let(:combinations) { subject.find_combinations([1, 2, 3, 4], 2) }

      it "should find all possible combinations" do
        combinations.should match_arrays([1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4])
      end
    end

    describe "when finding combinations of 0" do
      let(:combinations) { subject.find_combinations([1, 2, 3, 4], 0) }

      it "should find no possible combinations" do
        combinations.should be_empty
      end
    end
  end

  describe "when providing an always false condition" do
    subject do
      ConditionalCombinator.build do |c|
        c.comparator { false }
      end
    end
    let(:combinations) { subject.find_combinations([1, 2, 3, 4], 2) }

    it "should always return no possible combinations" do
      combinations.should be_empty
    end
  end

  describe "when providing a condition that specifies that the compared element shouldn't be contained in the elements already combined" do
    subject do
      ConditionalCombinator.build do |c|
        c.comparator { |combination_stack, value| !combination_stack.include?(value) }
      end
    end
    let(:combinations) { subject.find_combinations([1, 2, 3, 4, 4], 2) }
  
    it "should return all possible combinations with duplicated 4 combinations" do
      combinations.should match_arrays([1, 2], [1, 3], [1, 4], [1, 4], [2, 3], [2, 4], [2, 4], [3, 4], [3, 4])
    end
  end

  describe "when providing concrete objects" do
    subject do
      ConditionalCombinator.build do |c|
        c.comparator do |concrete_objects_stack, concrete_object|
          concrete_objects_stack.none? { |comparable_concrete_object| concrete_object.conflicts_with? comparable_concrete_object }
        end
      end
    end

    describe "when providing a set of 4 concrete objects" do
      let(:concrete_object_1) { ConcreteObject.new 1 }
      let(:concrete_object_2) { ConcreteObject.new 2 }
      let(:concrete_object_3) { ConcreteObject.new 3 }
      let(:concrete_object_4) { ConcreteObject.new 4 }
      let(:concrete_objects) { [concrete_object_1, concrete_object_2, concrete_object_3, concrete_object_4] }

      before(:each) do
        concrete_object_1.conflicts_with concrete_object_2
        concrete_object_2.conflicts_with concrete_object_1

        concrete_object_1.conflicts_with concrete_object_3
        concrete_object_3.conflicts_with concrete_object_1

        concrete_object_1.conflicts_with concrete_object_4
        concrete_object_4.conflicts_with concrete_object_1
      end

      it "should find no possible combinations of 0" do
        subject.find_combinations(concrete_objects, 0).should be_empty
      end

      it "should find all possible combinations of 1" do
        subject.find_combinations(concrete_objects, 1).should match_arrays \
        [concrete_object_1],
        [concrete_object_2],
        [concrete_object_3],
        [concrete_object_4]
      end

      it "should find all possible combinations of 2" do
        subject.find_combinations(concrete_objects, 2).should match_arrays \
        [concrete_object_2, concrete_object_3],
        [concrete_object_2, concrete_object_4],
        [concrete_object_3, concrete_object_4]
      end

      it "should find all possible combinations of 3" do
        subject.find_combinations(concrete_objects, 3).should match_arrays \
        [concrete_object_2, concrete_object_3, concrete_object_4]
      end

      it "should find all possible combinations of 4" do
        subject.find_combinations(concrete_objects, 4).should be_empty
      end
    end

    describe "when providing a set of 5 concrete objects" do
      let(:concrete_object_1) { ConcreteObject.new 1 }
      let(:concrete_object_2) { ConcreteObject.new 2 }
      let(:concrete_object_3) { ConcreteObject.new 3 }
      let(:concrete_object_4) { ConcreteObject.new 4 }
      let(:concrete_object_5) { ConcreteObject.new 5 }
      let(:concrete_objects) { [concrete_object_1, concrete_object_2, concrete_object_3, concrete_object_4, concrete_object_5] }

      before(:each) do
        concrete_object_1.conflicts_with concrete_object_3
        concrete_object_3.conflicts_with concrete_object_1

        concrete_object_2.conflicts_with concrete_object_5
        concrete_object_5.conflicts_with concrete_object_2
      end

      it "should find no possible combinations of 0" do
        subject.find_combinations(concrete_objects, 0).should be_empty
      end

      it "should find all possible combinations of 1" do
        subject.find_combinations(concrete_objects, 1).should match_arrays \
        [concrete_object_1],
        [concrete_object_2],
        [concrete_object_3],
        [concrete_object_4],
        [concrete_object_5]
      end

      it "should find all possible combinations of 2" do
        subject.find_combinations(concrete_objects, 2).should match_arrays \
        [concrete_object_1, concrete_object_2],
        [concrete_object_1, concrete_object_4],
        [concrete_object_1, concrete_object_5],
        [concrete_object_2, concrete_object_3],
        [concrete_object_2, concrete_object_4],
        [concrete_object_3, concrete_object_4],
        [concrete_object_3, concrete_object_5],
        [concrete_object_4, concrete_object_5]
      end

      it "should find all possible combinations of 3" do
        subject.find_combinations(concrete_objects, 3).should match_arrays \
        [concrete_object_1, concrete_object_2, concrete_object_4],
        [concrete_object_1, concrete_object_4, concrete_object_5],
        [concrete_object_2, concrete_object_3, concrete_object_4],
        [concrete_object_3, concrete_object_4, concrete_object_5]
      end

      it "should find all possible combinations of 4" do
        subject.find_combinations(concrete_objects, 4).should be_empty
      end

      it "should find all possible combinations of 5" do
        subject.find_combinations(concrete_objects, 5).should be_empty
      end
    end
  end

  describe "when providing concrete objects with a filter" do
    subject do
      ConditionalCombinator.build do |c|
        c.comparator do |concrete_objects_stack, concrete_object|
          concrete_objects_stack.none? { |comparable_concrete_object| concrete_object.conflicts_with? comparable_concrete_object }
        end
        c.shovel_filter do |concrete_objects_stack|
          concrete_objects_stack.none? { |concrete_object| concrete_object.id == 3 }
        end
      end
    end

    describe "when providing a set of 5 concrete objects" do
      let(:concrete_object_1) { ConcreteObject.new 1 }
      let(:concrete_object_2) { ConcreteObject.new 2 }
      let(:concrete_object_3) { ConcreteObject.new 3 }
      let(:concrete_object_4) { ConcreteObject.new 4 }
      let(:concrete_object_5) { ConcreteObject.new 5 }
      let(:concrete_objects) { [concrete_object_1, concrete_object_2, concrete_object_3, concrete_object_4, concrete_object_5] }

      before(:each) do
        concrete_object_1.conflicts_with concrete_object_3
        concrete_object_3.conflicts_with concrete_object_1

        concrete_object_2.conflicts_with concrete_object_5
        concrete_object_5.conflicts_with concrete_object_2
      end

      it "should find all possible combinations of 2" do
        subject.find_combinations(concrete_objects, 2).should match_arrays \
        [concrete_object_1, concrete_object_2],
        [concrete_object_1, concrete_object_4],
        [concrete_object_1, concrete_object_5],
        [concrete_object_2, concrete_object_4],
        [concrete_object_4, concrete_object_5]
      end

      it "should find all possible combinations of 3" do
        subject.find_combinations(concrete_objects, 3).should match_arrays \
        [concrete_object_1, concrete_object_2, concrete_object_4],
        [concrete_object_1, concrete_object_4, concrete_object_5]
      end
    end
  end
end

private

class ConcreteObject
  attr_reader :id

  def initialize(id)
    @id = id
    @conflicting_objects = []
  end

  def conflicts_with(concrete_object)
    @conflicting_objects << concrete_object
  end

  def conflicts_with?(concrete_object)
    @conflicting_objects.any? { |conflicting_object| conflicting_object == concrete_object }
  end
end
