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
  VERSION = '1.0.0'
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

  # Yields each LinkedList::Node (or subclass)
  def each_node
    node = cdr
    while node
      yield node
      node = node.cdr
    end
  end
  protected :each_node

  # Returns an Array that has the same values as this LinkedList
  def to_a
    inject(Array.new) do |memo, value|
      memo << value
    end
  end

  def at(index)
    index = normalize_index(index)
    each_with_index do |value, idx|
      return value if index == idx
    end
    nil
  end
  
  def normalize_index(index)
    index < 0 ? (length + index) : index
  end
  protected :normalize_index

  def [](*args)
    case args.length
    when 1
      case args.first
      when Range
        indexes = args.first
        start, stop = normalize_index(indexes.first), normalize_index(indexes.exclude_end? ? indexes.last - 1 : indexes.last)
        indexes = (start .. stop)
        result = []
        each_with_index do |value, idx|
          next unless indexes.include?(idx)
          result << value
        end
        result
      else
        at(args.first)
      end
    when 2
      index = normalize_index(args.first)
      return nil unless (0 .. length).include?(index)
      count = args.last
      self[index ... (index + count)]
    else
      raise ArgumentError, "Expected (index), (index, length) or (index0..index1), received #{args.inspect}"
    end
  end

  # Returns a new instance of self with a reverse insertion order
  def reverse
    list = new_species
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
    @cdr = new_node(value, cdr)
    @lcdr = @cdr if @lcdr.nil?
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
    @lcdr = nil if empty?
    value
  end
  alias_method :shift, :pop

  # Initializes this list to the empty state
  def clear
    @cdr, @lcdr, @size = nil, nil, 0
  end

  # Returns the first value of this list
  def first
    cdr.nil? ? nil : cdr.value
  end

  # Returns the last value of this list
  def last
    return nil if empty?
    @lcdr.value
  end

  def concat(other)
    result = new_species
    other.reverse.each do |value|
      result << value
    end
    self.reverse.each do |value|
      result << value
    end
    result
  end
  alias_method :+, :concat

  # Returns a new instance of the same class as self.
  def new_species
    self.class.new
  end
  protected :new_species

  # Returns a new node instance.
  def new_node(value, cdr)
    node_class.new(value, cdr)
  end
  protected :new_node

  # Returns the class of node to use.  Defaults to LinkedList::Node.
  def node_class
    LinkedList::Node
  end
  protected :node_class

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
