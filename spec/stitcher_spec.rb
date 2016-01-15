require_relative './spec_helper'

def error_check obj
	begin
		obj.func(4)
	rescue NoMethodError
		raise NoMethodError
	end
end

def stitcher_test obj
	describe Stitcher do
		describe "Stitcher::#{obj.class.name}" do
			it "obj.func(Object | !Fixnum)" do
				expect{ obj.func(4) }.to raise_error NoMethodError
				expect(obj.func [1, 2, 3]).to eq [1, 2, 3, 1, 2, 3]
			end
			it "obj.func(String)" do
				expect(obj.func "10").to eq 20
			end
			it "obj.func(Fixnum | Float, Float)" do
				expect(obj.func 10, 3.14).to eq 13
				expect(obj.func 3.14, 5.04).to eq 8
			end
			it "obj.func(Numeric, String)" do
				expect(obj.func 3, "10").to eq 13
				expect(obj.func 3.15, "4").to eq 7.15
			end
		end
	end
end


class TestExtend
	extend Stitcher
	using Stitcher::ClassOperators

	def func a
		a.to_i + a.to_i
	end
	stitcher_register :func, [String]

	stitcher_require [Object & !Fixnum]
	def func a
		a + a
	end

	def test_impl a, b
		(a + b).to_i
	end
	stitcher_define_method(:func, a: Fixnum | Float, b: Float){
		test_impl a, b
	}

	stitcher_register :func, [Numeric, String] do |a, b|
		a + b.to_i
	end
end
stitcher_test TestExtend.new


using Stitcher

class TestRegister
	def func a
		a.to_i + a.to_i
	end
	stitcher_register :func, [String]

	stitcher_require [Object & !Fixnum]
	def func a
		a + a
	end

	def func a, b
		(a + b).to_i
	end
	stitcher_register :func, [Fixnum | Float, Float]

	stitcher_register :func, [Numeric, String] do |a, b|
		a + b.to_i
	end
end
stitcher_test TestRegister.new

