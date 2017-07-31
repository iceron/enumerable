module Enumerable
  #my_each: replica of native each method
  def my_each
    if block_given?
      for i in 0.upto(self.length-1)
        yield self[i]
      end
    else
      self.to_enum
    end
  end
  #my_each_with_index: replica of native each_with_index method
  def my_each_with_index
    if block_given?
      for i in 0.upto(self.length-1)
        yield self[i], i
      end
    else
      self.to_enum
    end
  end
  #my_select: replica of native select method
  def my_select
    if block_given?
      arr = Array.new
      self.my_each do |x|
        if yield x
          arr << x
        end
      end
      arr
    else
      self.to_enum
    end
  end
  #my_all?: replica of native all? method
  def my_all?
    all = true
    self.my_each do |x|
      if !block_given?
        if !x || x.nil?
          all = false
        end
      elsif !yield x
        all = false
      end
      break if all == false
    end
    all
  end
  #my_any?: replica of native any? method
  def my_any?
    all = false
    self.my_each do |x|
      if !block_given?
        if x || !x.nil?
          all = true
        end
      elsif yield x
        all = true
      end
      break if all == true
    end
    all
  end
  #my_none?: replica of native none? method
  def my_none?
    all = true
    self.my_each do |x|
      if !block_given?
        if x
          all = false
        end
      elsif yield x
        all = false
      end
      break if all == false
    end
    all
  end
  #my_count: replica of native count method
  def my_count(e = nil)
    count = 0
    if !e.nil?
      self.my_each do |x|
        if x == e
          count = count + 1
        end
      end
    elsif block_given?
      self.my_each do |x|
        if yield x
          count = count + 1
        end
      end
    else
      count = self.length
    end
    count
  end
  #my_map?: replica of native map method
  def my_map(&block)
    array = Array.new
    self.my_each do |x|
      array << block.call(x)
    end
    array
  end
  #my_inject?: replica of native inject method
  def my_inject(&block)
    accum = 1
    self.my_each do |x|
      accum = block.call(accum, x)
    end
    accum
  end
end

#multiply_els for testing my_inject enumerable
def multiply_els(array)
  array.my_inject {|product, n| product * n}
end


#initialize Array
arr = [1,2,3,4,5,0]
p "default array: #{arr}"

#test my_each: prints array values
p "printing array values with my_each:"
arr.my_each do |x|
  puts x
end

#test my_each_with index: prints index and values
p "printing index array values with my_each_with_index:"
arr.my_each_with_index do |x, index|
  puts "arr[#{index}] = #{x}"
end

#test my_select: select items that are less than or equal to 2
p "using my_select to select from array elements that are less than or equal to two:"
p arr.my_select {|x| x <= 2}

#test my_all?: returns true if all elements are less than or equal to 2 (false otherwise)
p "using my_all? to check if all elements are less than or equal to two:"
p arr.my_all? {|x| x <= 2}

#test my_any?: returns true if there are any element that less than or equal to 2 (false otherwise)
p "using my_any? to check if there is an element less than or equal to two:"
p "starting array: #{[false, nil, nil, false, 1, nil]}"
p [false, nil, nil, false, 1, nil].my_any?

#test my_none?: returns true if none of the elements returns true (false otherwise)
p "using my_none? to check if none of the elements returns true:"
p "starting array: #{[false, nil, nil, false, false, nil]}"
p [false, nil, nil, false, false, nil].my_none?

#test my_count?: returns count with no arguments, with argument, and with block
p "testing my_count: "
p "no args: "
p arr.my_count
p "with argument (2): "
p arr.my_count(2)
p "with block (x <= 2)"
p arr.my_count {|x| x <= 2}

#test my_map: returns a new array based on block given
p "testing my_map: "
#using block
p "using block: "
p arr.my_map {|x| x * 2}
#using proc
p "using proc: "
a = Proc.new {|x| x * 2}
p arr.my_map(&a)

#test my_inject: combines all elements of an enum using a binary operation
p "testing my_inject with numbers and letters: "
p multiply_els([1,2,3,4,5]) #using multiply_els (numbers)
p (['a','b','c','d','e']).inject {|sum, n| sum + n} #using an array of letters
