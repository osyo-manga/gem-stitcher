require "stitcher"

# Using stitcher library.
using Stitcher

class X
	# Define accessor with variable type(Class).
	stitcher_accessor name: String, age: Integer

	def set name, age
		self.name = name
		self.age  = age
	end
	# Stitch method with Argument types.
	stitch :set, [String, Integer]

	# Define "set" method with Argument types.
	# set(Integer, String)
	stitcher_define_method(:set, age: Integer, name: String){
		self.name = name
		self.age  = age
	}

	# Define "set" method.
	stitch.set(ary: [String, Integer]){
		set *ary
	}

	def print
		p "name:#{name} age:#{age}"
	end
end

x = X.new
x.name = "homu"
x.age  = 14
# x.age = 14.0		# Error: No match method.

x.set "mami", 15
x.print
# => "name:mami age:15"

x.set 14, "mado"
x.print
# => "name:mado age:14"

x.set ["homu", 14]
x.print
# => "name:homu age:14"

