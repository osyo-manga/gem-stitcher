require_relative './spec_helper'


class Super
	extend Stitcher

	def plus a, b
		"#{a}:#{b}"
	end
	stitcher_register :plus, [String, String]
end

class X < Super

	def initialize value
		@value = value
	end
	stitcher_register :initialize, [Fixnum]

	def plus a
		@value + a
	end
	stitcher_register :plus, [Fixnum]

	def plus a, b
		@value + a + b
	end
	stitcher_register :plus, [Fixnum, Fixnum]

	def plus a
		@value + a.to_i
	end
	stitcher_register :plus, [String]
end

describe "Stitcher::Register" do
	x = X.new 10

	it "X#plus(Fixnum)" do
		expect(x.plus 42).to eq 52
	end
	it "X#plus(Fixnum, Fixnum)" do
		expect(x.plus 42, 2).to eq 54
	end
	it "X#plus(String)" do
		expect(x.plus "42").to eq 52
	end

	it "X#plus(String, String)" do
		expect(x.plus "42", "10").to eq "42:10"
	end

# 	it "X#plus(Other)" do
# 		expect(x.plus [1, 2]).to eq 10
# 	end
end
