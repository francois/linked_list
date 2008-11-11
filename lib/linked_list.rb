$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "linked_list/node"

# Linked list implementation.
# Linked lists have O(1) insertions and pops.  Traversal is O(n).
#
# == Implementation Notes
# This implementation isn't thread safe.  In fact, traversal is thread safe, but insertions and removals aren't.
#
# This implementation has problems with #dup, but beyond that, it looks fine.  It needs to be battle tested though.
# As a performance optimization, #size is cached and maintained locally, instead of being recalculated everytime.
class LinkedList
  VERSION = '0.0.1'
  include Enumerable

  attr_reader :cdr, :size
  alias_method :length, :size

  def initialize
    clear
  end

  # Two lists are equal if they have the same values in the same positions.
  def ==(other)
    cdr == other.cdr
  end

  # A list is empty if it doesn't have any nodes.
  def empty?
    cdr.nil?
  end

  # Returns a duplicate of this list, where the nodes are also copied.
  # FIXME: Performance hog...  The implementation sucks big time.
  def dup
    reverse.reverse
  end

  # Yields each value
  def each
    each_node do |node|
      yield node.value
    end
  end

  # Yields each LinkedList::Node
  def each_node
    node = cdr
    while node
      yield node
      node = node.cdr
    end
  end

  # Returns an Array that has the same values as this LinkedList
  def to_a
    inject(Array.new) do |memo, value|
      memo << value
    end
  end

  def at(index)
    index = (length + index) if index < 0
    each_with_index do |value, idx|
      return value if index == idx
    end
    nil
  end

  # Returns a new instance of self with a reverse insertion order
  def reverse
    list = self.class.new
    each do |value|
      list << value
    end
    list
  end

  # Destructively maps this list's values to the return value of the block
  def map!
    each_node do |node|
      node.value = yield(node.value)
    end
  end

  # Returns a new instance of self where the values have been replaced with the results of the block's
  def map(&block)
    list = dup
    list.map!(&block)
    list
  end

  # Pushes a new value at the head of this list
  def <<(value)
    @cdr = Node.new(value, cdr)
    @size += 1
    self
  end
  alias_method :push, :<<
  alias_method :unshift, :<<

  # Pops the head of the list, returning the value
  def pop
    return nil if empty?
    @size -= 1
    value = cdr.value
    @cdr = cdr.cdr
    value
  end
  alias_method :shift, :pop

  # Initializes this list to the empty state
  def clear
    @cdr, @size = nil, 0
  end

  # Returns the first value of this list
  def first
    cdr.nil? ? nil : cdr.value
  end

  # Returns the last value of this list
  def last
    return nil if empty?
    node = cdr
    while node
      prev = node
      node = node.cdr
    end
    prev.value
  end

  # Returns a nice looking view of this list.
  #  list = LinkedList.new
  #  list.push "a"
  #  list.push "b"
  #  list.inspect
  #  #=> ("b" ("a" nil))
  def inspect
    cdr.inspect
  end
end
