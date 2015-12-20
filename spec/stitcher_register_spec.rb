require_relative './spec_helper'

class X
	extend Stitcher

	def initialize value
		@value = value
	end
	stitcher_register :initialize, [Fixnum]

	def plus a
		@value + a
	end
	stitcher_register :plus, [Fixnum]

	def plus a
		@value + a.to_i
	end
	stitcher_register :plus, [String]

	def plus a
		@value
	end
	stitcher_register :plus, proc { true }
end

describe "Stitcher::Register" do
	x = X.new 10

	it "X#plus(Fixnum)" do
		expect(x.plus 42).to eq 52
	end
	it "X#plus(String)" do
		expect(x.plus "42").to eq 52
	end

	it "X#plus(Other)" do
		expect(x.plus [1, 2]).to eq 10
	end
end
