require "stitcher"

class X
	extend Stitcher

	def func
		""
	end
	stitcher_register :func, []

	def func a, b
		"Integer, String"
	end
	stitcher_register :func, [Integer, String]

	def func a, b
		"Integer, Array"
	end
	stitcher_register :func, [Integer, Array]

	def func a
		"Integer"
	end
	stitcher_register :func, [Integer]
end

x = X.new

p x.func
# => ""

p x.func 42, "homu"
# => "Integer,String"

p x.func 42, []
# => "Integer, Array"

p x.func 42
# => "Integer"

