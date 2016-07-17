#Go through first array while comparing to second array
#If common, push to common
#Delete common


def common2(arr1, arr2)
  common = []
  arr1.each do |ele|
    arr2.each do |ele2|
     if ele == ele2
      common << ele 
      arr1.delete(ele)
      arr2.delete(ele2)
    end
  end
end
  p common
end

#A = [13, 27, 35, 40, 49, 55, 59]
#B = [17, 35, 39, 40, 55, 58, 60]

def common(arr1, arr2)
  arr1.select {|x| arr2.include?(x)}
end

p common2([13, 27, 35, 40, 49, 55, 59],[17, 35, 39, 40, 55, 58, 60] )


# Given two sorted arrays, find the elements in common.
# The arrays are the same length and each has all distinct elements.


A = [13, 27, 35, 40, 49, 55, 59]
B = [17, 35, 39, 40, 55, 58, 60]

# Pseudo code here
# then
# Your code here

#=> [35, 40, 55]

# Naive solution O(n^2)
# Nested full collection iterations
# means squared time

shared = A.select { |n| B.include?(n) }
p shared


# Better solution O(n)
# Not clear
# Nested loops, however the inner loop
# edges along and does not do a full iteration
# However, it is still unclear how close
# to linear time this algo will run

i = 0
shared = B.each_with_object([]) do |n, array|
  while i < A.length && A[i] < n
    i += 1
  end
  array << n if A[i] == n
end
p shared


# Best solution O(n)
# Because this algo runs two consecutive loops
# it is definitively linear
# It uses a hash to store values once
# and creating a key/value on a hash is constant time

c = B.each_with_object({}) do |n, hash|
  hash[n] = true
end
shared = A.select { |n| c.has_key?(n) }

p shared