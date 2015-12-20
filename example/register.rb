require "stitcher"

class X
	extend Stitcher

	def initialize value
		@value = value
	end
	# Register method argument types.
	stitcher_register :initialize, [Fixnum]

	# Define multi methods.
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

# Call X#plus(Fixnum)
p x.plus -3
# => 7

# Call X#plus(String)
p x.plus "42"
# => 57
