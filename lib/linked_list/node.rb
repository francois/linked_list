class LinkedList
  # Implements a single node of the linked list.
  class Node
    attr_accessor :cdr, :value

    def initialize(value, cdr)
      @cdr, @value = cdr, value
    end

    # Two nodes are equal if their values are equal and their cdr's are equal too.
    def ==(other)
      cdr == other.cdr && value == other.value
    end

    # Returns a nice-looking string.
    #  node = LinkedList::Node.new("a", nil)
    #  node.inspect
    #  #=> ("a" nil)
    def inspect
      "(#{value.inspect} #{cdr.inspect})"
    end
  end
end
