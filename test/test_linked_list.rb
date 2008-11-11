require File.dirname(__FILE__) + '/test_helper.rb'

class TestLinkedList < Test::Unit::TestCase
  context "An empty LinkedList" do
    setup do
      @list = LinkedList.new
    end

    context "#push'ing a value of nil" do
      setup do
        @list.push nil
      end

      should "have a length of 1" do
        assert_equal 1, @list.length
      end

      should "be equal to [nil]" do
        assert_equal [nil], @list.to_a
      end
    end

    context "#push'ing an element" do
      setup do
      @list.push "a"
      end

      should "be equal to ['a']" do
        assert_equal %w(a), @list.to_a
      end
    end

    context "calling #reverse" do
      setup do
        @other = @list.reverse
      end

      should "return another list instance" do
        assert_not_same @list, @other
      end

      should "return an empty list" do
        assert @other.empty?
      end
    end

    context "calling #to_a" do
      setup do
        @other = @list.to_a
      end

      should "be an Array" do
        assert_kind_of Array, @other
      end

      should "be empty" do
        assert @other.empty?
      end
    end

    should "return nil on #at(0)" do
      assert_nil @list.at(0)
    end

    should "return nil on #at(-1)" do
      assert_nil @list.at(-1)
    end

    should "return nil on #[](1)" do
      assert_nil @list[1]
    end

    should "return nil on #[](-1)" do
      assert_nil @list[-1]
    end

    should "return nil on #[](0, 1)" do
      assert_equal [], @list[0, 1]
    end

    should "return nil on #[](0..1)" do
      assert_equal [], @list[0..1]
    end

    should "return nil on #[](0)" do
      assert_nil @list[0]
    end

    should "return a new instance when calling #dup" do
      assert_not_same @list, @list.dup
    end

    should "return nil for #first" do
      assert_nil @list.first
    end

    should "return nil for #last" do
      assert_nil @list.last
    end

    should "be empty" do
      assert @list.empty?
    end

    should "have a length of 0" do
      assert_equal 0, @list.length
    end

    should "have a size of 0" do
      assert_equal 0, @list.size
    end

    should "never call the #each block" do
      yielded = 0
      @list.each do |value|
        yielded += 1
      end
      assert yielded.zero?
    end
  end

  context "A linked list with one element" do
    setup do
      @list = LinkedList.new
      @list << "a"
    end

    context "calling #pop" do
      setup do
        @element = @list.pop
      end

      should "be empty?" do
        assert @list.empty?
      end

      should "return the element" do
        assert_equal "a", @element
      end

      should "have a size of 0" do
        assert @list.size.zero?
      end
    end

    context "calling #to_a" do
      setup do
        @other = @list.to_a
      end

      should "be equal to ['a']" do
        assert_equal %w(a), @other
      end
    end

    context "calling #reverse" do
      setup do
        @other = @list.reverse
      end

      should "be equal to the initial list" do
        assert_equal @list, @other
      end
    end

    context "calling #dup" do
      setup do
        @other = @list.dup
      end
      
      should "be a new instance" do
        assert_not_same @list, @other
      end

      should "have duplicated the nodes" do
        @list.map! {|value| value*2}
        assert_not_equal @list, @other
      end
    end

    should "return 'a' for #at(-1)" do
      assert_equal "a", @list.at(-1)
    end

    should "return 'a' for #at(0)" do
      assert_equal "a", @list.at(0)
    end

    should "return nil for #at(2)" do
      assert_nil @list.at(2)
    end

    should "return nil for #at(-2)" do
      assert_nil @list.at(-2)
    end

    should "return nil for #at(1)" do
      assert_nil @list.at(1)
    end

    should "return 'a' for #first" do
      assert_equal "a", @list.first
    end

    should "return 'a' for #last" do
      assert_equal "a", @list.last
    end

    should "NOT be empty?" do
      assert !@list.empty?
    end

    should "have a size of 1" do
      assert_equal 1, @list.size
    end

    should "yield the single element to the #each block" do
      @list.each do |value|
        assert_equal "a", value
      end
    end

    should "yield once calling #each" do
      yielded = 0
      @list.each do |value|
        yielded += 1
      end
      assert_equal 1, yielded
    end

    should "yield the value and the index when calling #each_with_index" do
      yields = []
      @list.each_with_index do |value, index|
        yields << [value, index]
      end
      assert_equal [["a", 0]], yields
    end

    should "include?('a')" do
      assert @list.include?("a")
    end

    should "NOT include?('b')" do
      assert !@list.include?("b")
    end
  end

  context "A list with 2 elements" do
    setup do
      @list = LinkedList.new
      @list << "a"
      @list << "b"
    end

    context "calling #to_a" do
      setup do
        @other = @list.to_a
      end

      should "be equal to ['b', 'a']" do
        assert_equal %w(b a), @other
      end
    end

    context "calling #reverse" do
      setup do
        @other = @list.reverse
      end

      should "return the elements in insertion order" do
        assert_equal %w(a b), @other.to_a
      end
    end

    context "cleared" do
      setup do
        @list.clear
      end

      should "be empty?" do
        assert @list.empty?
      end
    end

    context "#map" do
      setup do
        @other = @list.map {|f| f*2}
      end

      should "return a list of 2 elements" do
        assert_equal 2, @other.length
      end

      should "include?('aa')" do
        assert @other.include?("aa")
      end

      should "include?('bb')" do
        assert @other.include?("bb")
      end

      should "NOT have reversed the list" do
        assert_equal %w(bb aa), @other.to_a
      end
    end

    context "calling #pop" do
      setup do
        @element = @list.pop
      end

      should "NOT be empty?" do
        assert !@list.empty?
      end

      should "return the moast recently pushed element" do
        assert_equal "b", @element
      end

      should "have a size of 1" do
        assert_equal 1, @list.size
      end
    end

    should "return 'b' for #at(0)" do
      assert_equal "b", @list.at(0)
    end

    should "return 'a' for #at(1)" do
      assert_equal "a", @list.at(1)
    end

    should "return 'a' for #at(-1)" do
      assert_equal "a", @list.at(-1)
    end

    should "return 'b' for #at(-2)" do
      assert_equal "b", @list.at(-2)
    end

    should "return 'b' for #first" do
      assert_equal "b", @list.first
    end

    should "return 'a' for #last" do
      assert_equal "a", @list.last
    end

    should "include?('b')" do
      assert @list.include?("b")
    end

    should "have a length of 2" do
      assert_equal 2, @list.length
    end

    should "yield the value and the index when calling #each_with_index" do
      yields = []
      @list.each_with_index do |value, index|
        yields << [value, index]
      end
      assert_equal [["b", 0], ["a", 1]], yields
    end
  end

  context "A list with 5 elements" do
    setup do
      @list = LinkedList.new
      @list << "a" << "b" << "c" << "d" << "e"
    end

    should "have a length of 5" do
      assert_equal 5, @list.length
    end

    should "return 'a' for #at(-1)" do
      assert_equal "a", @list.at(-1)
    end

    should "return 'e' for #at(-5)" do
      assert_equal "e", @list.at(-5)
    end

    should "return ['e', 'd', 'c', 'b', 'a'] for #[](0..10)" do
      assert_equal %w(e d c b a), @list[0..10]
    end

    should "return ['e', 'd'] for #[](0..1)" do
      assert_equal %w(e d), @list[0..1]
    end

    should "return ['e'] for #[](0..0)" do
      assert_equal %w(e), @list[0..0]
    end

    should "return ['e', 'd', 'c'] for #[](0..2)" do
      assert_equal %w(e d c), @list[0..2]
    end

    should "return ['e', 'd', 'c', 'b', 'a'] for #[](0, 10)" do
      assert_equal %w(e d c b a), @list[0, 10]
    end

    should "return ['e'] for #[](0, 1)" do
      assert_equal %w(e), @list[0, 1]
    end

    should "return ['e', 'd'] for #[](0, 2)" do
      assert_equal %w(e d), @list[0, 2]
    end

    should "return nil for #[](-240)" do
      assert_nil @list[-240]
    end

    should "return nil for #[](240)" do
      assert_nil @list[240]
    end

    should "return nil for #[](-240, 100)" do
      assert_nil @list[-240, 100]
    end

    should "return nil for #[](240, 100)" do
      assert_nil @list[240, 100]
    end

    should "return ['b', 'a'] for #[](-2..-1)" do
      assert_equal %w(b a), @list[-2..-1]
    end

    should "return ['c', 'b'] for #[](-3, 2)" do
      assert_equal %w(c b), @list[-3, 2]
    end
  end
end
