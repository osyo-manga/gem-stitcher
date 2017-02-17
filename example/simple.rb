require "stitcher"

# Using stitcher library.
using Stitcher

class Person
	# Define accessor with variable type(Class).
	stitcher_accessor name: String, age: Integer

	def set name, age
		self.name = name
		self.age  = age
	end
	# Register set method with Argument types(Classes).
	# stitcher_register signature, method_name
	# signature request #=== method.
	stitcher_register [String, Integer], :set

	# Register for next define method.
	stitcher_require [Hash]
	def set hash
		set hash[:name], hash[:age]
	end

	# Define "set" method with Argument types.
	stitcher_define_method([Array], :set){ |ary|
		set *ary
	}

	# Define arugment wit name
	stitcher_def.set(age: Integer, name: String){
		self.name = name
		self.age  = age
	}

	stitcher_require []
	def print
		p "name:#{name} age:#{age}"
	end

	# Require block
	stitcher_require Stitcher::Concepts.blockable
	def print fmt
		printf(fmt, *yield(name, age))
	end
end

person = Person.new
person.name = "homu"
person.age  = 14
# person.age = 14.0		# Error: No match method.

person.set "mami", 15
person.print
# => "name:mami age:15"

person.set({ name: "saya", age: 14 })
person.print
# => "name:saya age:14"

person.set 14, "mado"
person.print("%s-%s\n"){ |name, age| [name, age] }
# => mado-14

person.set ["homu", 14]
person.print("%s-%s\n"){ |name, age| [age, name] }
# => 14-homu
