require_relative './spec_helper'


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
				expect{ obj.func(3.14, 5) }.to raise_error NoMethodError
			end
			it "obj.func(Numeric, String)" do
				expect(obj.func 3, "10").to eq 13
				expect(obj.func 3.15, "4").to eq 7.15
				expect{ obj.func("10", 5) }.to raise_error NoMethodError
			end
		end
	end
end

using Stitcher::Operators

class TestExtend
	extend Stitcher

	stitcher_require [Object & !Fixnum]
	def func a
		a + a
	end

	def func a
		a.to_i + a.to_i
	end
	stitcher_register :func, [String]

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
	stitcher_require [Object & !Fixnum]
	def func a
		a + a
	end

	def func a
		a.to_i + a.to_i
	end
	stitcher_register :func, [String]

	def func a, b
		(a + b).to_i
	end
	stitcher_register :func, [Fixnum | Float, Float]

	stitcher_register :func, [Numeric, String] do |a, b|
		a + b.to_i
	end
end
# stitcher_test TestRegister.new



class TestPriority

end


describe "Stitcher" do
	describe "VariadicArgument" do
		it "true" do
			expect( +[Fixnum] === [1, 2, 3] ).to eq true
			expect( +[Fixnum] === [1] ).to eq true
			expect( +[String, Fixnum] === ["", 2] ).to eq true
			expect( +[String, Fixnum] === ["", 2, 3] ).to eq true
			expect( +[String, Fixnum, Float] === ["", 2, 3.0] ).to eq true
		end
		it "false" do
			expect( +[Fixnum] === [] ).to eq false
			expect( +[Fixnum] === [1, ""] ).to eq false
			expect( +[String, Fixnum] === [1] ).to eq false
			expect( +[String, Fixnum] === [""] ).to eq false
			expect( +[String, Fixnum] === ["", "", 1] ).to eq false
			expect( +[String, Fixnum] === ["", 1, ""] ).to eq false
			expect( +[String, Fixnum, Float] === ["", 2, 3] ).to eq false
		end
	end
	describe "Require" do
		class TestRequire
			def func n
				n
			end

			stitcher_require [Fixnum]
			def func n
				n + n
			end

			def func2 n
				n
			end
			stitch :func2, [String]

			stitcher_require [Fixnum]
			def func2 n
				n + n
			end

			stitcher_require []
			def func3
				nil
			end

			stitcher_require [Array]
			def func3 a
				a
			end
		end

		obj = TestRequire.new
		it "func" do
			expect(obj.func "test" ).to eq "test"
			expect(obj.func 10 ).to eq 20
			expect{obj.func(3, 5)}.to raise_error NoMethodError
		end

		it "func2" do
			expect(obj.func2 "test" ).to eq "test"
			expect(obj.func2 10 ).to eq 20
		end

		it "func3" do
			expect(obj.func3 [1, 2, 3] ).to eq [1, 2, 3]
			expect(obj.func3 ).to eq nil
			expect{obj.func3("")}.to raise_error NoMethodError
		end
	end


	describe "Priority" do
		class TestPriority
			stitcher_require [Object]
			def func a
				"Object"
			end

			stitcher_require [Numeric]
			def func a
				"Numeric"
			end
		end

		obj = TestPriority.new
		it "func" do
			expect(obj.func 10).to eq "Numeric"
			expect(obj.func 10.0).to eq "Numeric"
			expect(obj.func "").to eq "Object"
		end
	end

	describe "Accessor" do
		class TestAccessor
			stitcher_accessor name: String, age: Fixnum
		end
		obj = TestAccessor.new
		it "success" do
			obj.name = "homu"
			obj.age  = 14
			expect(obj.name).to eq "homu"
			expect(obj.age ).to eq 14
		end
		it "failed" do
			expect{ obj.name = 42     }.to raise_error NoMethodError
			expect{ obj.age  = "homu" }.to raise_error NoMethodError
		end
	end

	describe "DefineMethod" do
		class TestDefineMethod
			attr_accessor :name, :age

			stitcher_define_method(:set, name: String, age: Fixnum){
				self.name = name
				self.age  = age
			}
		end
		obj = TestDefineMethod.new

		it "call method" do
			obj.set("homu", 14)
			expect(obj.name).to eq "homu"
			expect(obj.age).to  eq 14
		end
	end
end

