require "stitcher"


class X
	# Using stitcher library in class.
	extend Stitcher

	# Define accessor with variable type(Class).
	stitch_accessor name: String, age: Integer

	# Define "set" method with Argument types.
	# set(String, Integer)
	define_stitch(:set, name: String, age: Integer){
		self.name = name
		self.age  = age
	}

	# Define other "set" method.
	# set(Integer, String)
	define_stitch(:set, age: Integer, name: String){
		# Call set(String, Integer)
		set name, age
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

