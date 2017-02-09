require_relative '../spec_helper'

using Module.new {
	refine Module do
		include Stitcher::Core
	end
}

describe Stitcher::Core do
	context "#stitcher_register" do
		let(:obj) { Object.new }

		subject{ obj.call 42, [1, 2] }

		context "メソッドを登録した場合" do
			before do
				class <<obj
					def call
						
					end
				end
			end
			subject { -> {
				class <<obj
					stitcher_register [], :call
				end
			} }
			it { is_expected.to change{ obj.method(:call) } }
		end

		context "1つだけメソッドを定義した場合" do
			before do
				class <<obj
					stitcher_register [Integer, Array],
					def call a, b
						true
					end
				end
			end
			it { is_expected.to be_truthy }
		end

		context "マッチするメソッドがなかった場合" do
			before do
				class <<obj
					stitcher_register [Integer, Integer],
					def call a, b
						true
					end
				end
			end
			it { expect{ subject }.to raise_error(NoMethodError) }
		end

		context "親クラスにマッチする場合" do
			before do
				class <<obj
					stitcher_register [Numeric, Array],
					def call a, b
						true
					end
				end
			end
			it { is_expected.to be_truthy }
		end

		context "複数メソッドを定義した場合" do
			before do
				class <<obj
					stitcher_register [Integer, Array],
					def call a, b
						false
					end

					stitcher_register [Integer, Array],
					def call a, b
						true
					end
				end
			end
			it { is_expected.to be_truthy }
		end

		context "親クラスのメソッドを呼び出す場合" do
			subject {
				Class.new (Class.new{
					stitcher_register [Integer, Array],
					def call a, b
						true
					end
				}){
					stitcher_register [Integer, Integer],
					def call a, b
						false
					end
				}
			}
			it { is_expected.to be_truthy }
		end
	end

	context "#stitcher_define_method" do
		context "インスタンス変数にアクセスする場合" do
			let(:obj){
				Class.new {
					attr_accessor :value
					stitcher_define_method [], :call do
						@value = 42
					end
				}.new
			}
			it { expect { obj.call }.to change { obj.value }.from(nil).to(42) }
		end
	end

	context "#stitcher_def" do
		let(:obj){
			Class.new {
				attr_accessor :value
				stitcher_def.call(a: Integer, b: String){
					a.to_s + b
				}

				stitcher_def.call(value: Integer){
					@value = value
				}

				stitcher_def.call {
					self
				}
			}.new
		}
		subject { obj.method(:call) }
		it { expect(subject.call 42, "homu").to eq "42homu" }
		it { expect(subject.call).to eq obj }
		it { expect(subject.call 42).to eq 42 }
		it { expect{ subject.call 42 }.to change { obj.value }.from(nil).to(42) }
		it { expect{ subject.call 42 }.to_not change { obj.singleton_class.ancestors } }
		it { expect{ subject.call }.to_not change { obj.singleton_class.ancestors } }
	end
end
