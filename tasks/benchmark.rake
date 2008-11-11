namespace :test do
  task :benchmark => %w(test) do
    require "benchmark"
    include Benchmark
    $:.unshift File.dirname(__FILE__) + "/../lib"
    require "linked_list"

    puts "Building a list of 1 million random strings"
    list = nil
    time = realtime do
      list = list_of_elements(1_000_000)
    end
    puts "Took %.3f seconds" % time
    puts "Converting to an array"
    array = nil
    time = realtime do
      array = list.to_a
    end
    puts "Took %.3f seconds" % time

    bm(16) do |x|
      x.report("list#push/pop")  do
        20_000.times do
          list.push "a"
        end
        20_000.times do
          list.pop
        end
      end
      x.report("array#push/pop") do
        20_000.times do
          array.push "a"
        end
        20_000.times do
          array.pop
        end
      end
    end

    bm(16) do |x|
      x.report("list#last")  { 20.times { list.last } }
      x.report("array#last") { 20.times { array.last } }
    end

    bm(16) do |x|
      x.report("list#first")  { 2_000.times { list.first } }
      x.report("array#first") { 2_000.times { array.first } }
    end

    bm(16) do |x|
      x.report("list#reverse")  { list.reverse }
      x.report("array#reverse") { array.reverse }
    end

    bm(16) do |x|
      x.report("list#dup")  { list.dup }
      x.report("array#dup") { array.dup }
    end
  end
end

def list_of_elements(count)
  list = LinkedList.new
  count.times do
    list <<  nil
  end
  list
end

CHARS = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('0' .. '9').to_a
LENGTH = CHARS.length
def random_string
  (0..10).inject("") {|str, _| str << CHARS[rand(LENGTH)]}
end
