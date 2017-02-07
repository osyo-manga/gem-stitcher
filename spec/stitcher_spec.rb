require_relative './spec_helper'

describe Stitcher do
	shared_examples "多重定義の呼び出し" do
		it { expect(subject.call()).to eq "" }
		it { expect(subject.call("")).to eq "String" }
		it { expect(subject.call(42)).to eq "Integer" }
		it { expect(subject.call(1, 2)).to eq "Integer, Integer" }
		it { expect(subject.call("", 0)).to eq "String, Integer" }
		it { expect(subject.call(0, "")).to eq "Integer, String" }

		it { expect{subject.call([])}.to raise_error(NoMethodError) }
		it { expect{subject.call([], "")}.to raise_error(NoMethodError) }
	end

	context "多重定義の呼び出し" do
		subject {
			Class.new {
				extend Stitcher

				[
					[],
					[Integer],
					[String],
					[Integer, Integer],
					[String, Integer],
					[Integer, String],
				].each { |sig|
					define_method(:call){ |*args|
						sig.map(&:to_s).join(", ")
					}
					stitcher_register sig, :call
				}
			}.new
		}
		it_behaves_like "多重定義の呼び出し"
	end

	context "親クラスのメソッド呼び出し" do
		subject {
			Class.new(Class.new{
				extend Stitcher

				[
					[Integer],
					[Integer, Integer],
					[Integer, String],
				].each { |sig|
					define_method(:call){ |*args|
						sig.map(&:to_s).join(", ")
					}
					stitcher_register sig, :call
				}
			}) {
				[
					[],
					[String],
					[String, Integer],
				].each { |sig|
					define_method(:call){ |*args|
						sig.map(&:to_s).join(", ")
					}
					stitcher_register sig, :call
				}
			}.new
		}
		it_behaves_like "多重定義の呼び出し"
	end
end
