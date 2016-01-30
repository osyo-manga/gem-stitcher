require_relative './spec_helper'


using Stitcher

class Super
# 	extend Stitcher

	def plus a, b
		"#{a}:#{b}"
	end
	stitcher_register :plus, [String, String]
end

class X < Super
	def impl a, b
		a + b
	end

	def initialize value
		@value = value
	end
	stitcher_register :initialize, [Fixnum]

	def plus a
		impl @value, a
	end
	stitcher_register :plus, [Fixnum]

	def plus a, b
		impl(impl(@value, a), b)
	end
	stitcher_register :plus, [Fixnum, Fixnum]

	stitcher_register :plus, [String] do |a|
		@value + a.to_i
	end

	stitcher_register :plus, [Float] do |a|
		# Can't call instance method and instance variable..
		impl @value, a
	end

	def func a, &block
		a.map &block
	end
	stitcher_register :func, [Array]
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
		expect{x.plus "42"}.to raise_error NoMethodError
	end

	it "X#plus(String, String)" do
		expect(x.plus "42", "10").to eq "42:10"
	end

	it "X#plus(Float)" do
		expect{x.plus 1.0}.to raise_error NoMethodError
	end

	it "X#func(Array) with block" do
		expect(x.func([1, 2, 3]){ |it| it + it}).to eq [2, 4, 6]
	end

	class << x
		def plus a
			"Symbol"
		end
		stitcher_register :plus, [Symbol]
	end

	it "x.func(Symbol) with block" do
		expect(x.plus(:homu)).to eq "Symbol"
	end

# 	it "X#plus(Other)" do
# 		expect(x.plus [1, 2]).to eq 10
# 	end
end
