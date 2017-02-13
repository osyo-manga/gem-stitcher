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

				stitcher_def.call(value: String){
					self.value = value
				}

				stitcher_def.call {
					self
				}
			}.new
		}
		it { expect(obj.call 42, "homu").to eq "42homu" }
		it { expect(obj.call).to eq obj }
		it { expect(obj.call 42).to eq 42 }
		it { expect{ obj.call 42 }.to change { obj.value }.from(nil).to(42) }
		it { expect{ obj.call "homu" }.to change { obj.value }.from(nil).to("homu") }
		it { expect{ obj.call 42 }.to_not change { obj.singleton_class.ancestors } }
		it { expect{ obj.call }.to_not change { obj.singleton_class.ancestors } }
	end

	context "#stitcher_accessor" do
		let(:obj){
			Class.new {
				stitcher_accessor name: String, age: Integer
			}.new
		}
		before do
			obj.name = "mami"
			obj.age  = 14
		end
		it { expect(obj.name).to eq "mami" }
		it { expect(obj.age ).to eq 14 }
		it { expect(obj.name = "homu").to eq "homu" }
		it { expect(obj.age = 13).to eq 13 }
		it { expect { obj.name = "homu" }.to change{ obj.name }.from("mami").to("homu") }
		it { expect { obj.age  = 13 }.to change{ obj.age }.from(14).to(13) }
		it { expect { obj.name = 14 }.to raise_error(NoMethodError) }
		it { expect { obj.age = "mami" }.to raise_error(NoMethodError) }
	end
end
