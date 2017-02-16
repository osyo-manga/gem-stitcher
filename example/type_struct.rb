require "stitcher"

using Stitcher

def type_struct **hash
	Class.new {
		stitcher_accessor hash
		def initialize **hash
			hash.each { |key, value| send("#{key}=", value) }
		end
	}
end

Human = type_struct(
    name: String,
    sex: String,
    age: Integer,
    address: String,
)

data = Human.new(
    name: "michael",
    sex: "man",
#     sex: 114514, #TypeError
    age: 48,
    address: "California,USA",
)


