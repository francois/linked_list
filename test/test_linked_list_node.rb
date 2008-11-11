require File.dirname(__FILE__) + '/test_helper.rb'

class TestLinkedListNode < Test::Unit::TestCase
  context "A node with the empty string as a value at the end of the chain" do
    setup do
      @node = LinkedList::Node.new("", nil)
    end

    should "be equal to itself" do
      assert_equal @node, @node
    end

    should "be equal to another node that is empty" do
      assert_equal @node, LinkedList::Node.new("", nil)
    end

    should "NOT be equal to another node that has a different value" do
      assert_not_equal @node, LinkedList::Node.new("a", nil)
    end

    should "NOT be equal to another node that has a different cdr" do
      assert_not_equal @node, LinkedList::Node.new("", LinkedList::Node.new(nil, nil))
    end

    should "be inspectable" do
      assert_equal "(\"\" nil)", @node.inspect
    end
  end

  context "A node with a value of 'a' and a successor of 'b'" do
    setup do
      @tail = LinkedList::Node.new("b", nil)
      @head = LinkedList::Node.new("a", @tail)
    end

    should "be inspectable" do
      assert_equal "(\"a\" (\"b\" nil))", @head.inspect
    end
  end

end
