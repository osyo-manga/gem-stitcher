require "stitcher"

class X
	extend Stitcher

	def initialize value
		@value = value
	end
	# Register method argument types.
	stitch :initialize, [Fixnum]

	# Define multi methods.
	def plus a
		@value + a
	end
	stitch :plus, [Fixnum]

	def plus a
		@value + a.to_i
	end
	stitch :plus, [String]
end

x = X.new 10
# x = X.new "10"		# Error: No match method.

# Call X#plus(Fixnum)
p x.plus -3
# => 7

# Call X#plus(String)
p x.plus "42"
# => 57
