require "stitcher"

class X
	extend Stitcher

	def initialize value
		@value = value
	end
	stitcher_register :initialize, [Fixnum]

	def plus a
		@value + a
	end
	stitcher_register :plus, [Fixnum]

	def plus a
		@value + a.to_i
	end
	stitcher_register :plus, [String]
end

x = X.new 10
# x = X.new "10"		# Error: No match method.

p x.plus -3
# => 7
p x.plus "42"
# => 57
