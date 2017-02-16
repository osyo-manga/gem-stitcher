require "stitcher"

using Stitcher

class X
	stitcher_require [Object]
	def func a
		"func{Object}"
	end

	stitcher_require [String]
	def func a
		"func{String}"
	end
end

x = X.new
p x.func 10
# => "func{Object}"
p x.func "homu"
# => "func{String}"

