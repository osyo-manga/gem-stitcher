require_relative './spec_helper'


class Super
	extend Stitcher

	def plus a, b
		"#{a}:#{b}"
	end
	stitch :plus, [String, String]
end

class X < Super

	def initialize value
		@value = value
	end
	stitch :initialize, [Fixnum]

	def plus a
		@value + a
	end
	stitch :plus, [Fixnum]

	def plus a, b
		@value + a + b
	end
	stitch :plus, [Fixnum, Fixnum]

	def plus a
		@value + a.to_i
	end
	stitch :plus, [String]
end

describe "Stitcher::Stitch" do
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
