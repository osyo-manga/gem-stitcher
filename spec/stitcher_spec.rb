require_relative './spec_helper'

describe Stitcher do
	shared_examples "多重定義の呼び出し" do
		let(:obj) {
			define_method_ = impl_define_method
			Class.new(Class.new{ |klass|
				extend Stitcher

				[
					[Numeric],
					[Integer, Integer],
					[Integer, String],
				].each { |sig|
					define_method_.call klass, sig, :call do |*args|
						sig.map(&:to_s).join(", ")
					end
				}
			}) { |klass|
				[
					[],
					[Integer],
					[String],
					[String, Integer],
				].each { |sig|
					define_method_.call klass, sig, :call do |*args|
						sig.map(&:to_s).join(", ")
					end
				}
				define_method_.call klass, proc { |n, _| Integer === n && n < 0 }, :call do |*args|
					"Under zero"
				end
			}.new
		}

		it { expect(obj.call()).to eq "" }
		it { expect(obj.call("")).to eq "String" }
		it { expect(obj.call(42)).to eq "Integer" }
		it { expect(obj.call(3.14)).to eq "Numeric" }
		it { expect(obj.call(1, 2)).to eq "Integer, Integer" }
		it { expect(obj.call(-3)).to eq "Under zero" }
		it { expect(obj.call("", 0)).to eq "String, Integer" }
		it { expect(obj.call(0, "")).to eq "Integer, String" }

		it { expect{obj.call([])}.to raise_error(NoMethodError) }
		it { expect{obj.call([], "")}.to raise_error(NoMethodError) }
	end

	context "Core#stticher_register" do
		it_behaves_like "多重定義の呼び出し" do
			let(:impl_define_method) {
				proc { |klass, sig, name, &block|
					klass.instance_eval {
						define_method(name, &block)
						stitcher_register sig, name
					}
				}
			}
		end
	end

	context "Core#stitcher_define_method" do
		it_behaves_like "多重定義の呼び出し" do
			let(:impl_define_method) {
				proc { |klass, sig, name, &block|
					klass.instance_eval {
						stitcher_define_method(sig, name, &block)
					}
				}
			}
		end
	end

	context "Core#stitcher_def" do
		it_behaves_like "多重定義の呼び出し" do
			let(:impl_define_method) {
				proc { |klass, sig, name, &block|
					klass.instance_eval {
						if Array === sig
							stitcher_def.__send__(name, Hash[[(:a..:z).to_a.take(sig.length), sig].transpose], &block)
						else
							stitcher_define_method(sig, name, &block)
						end
					}
				}
			}
		end
	end

	context "Core#stitcher_require" do
		it_behaves_like "多重定義の呼び出し" do
			let(:impl_define_method) {
				proc { |klass, sig, name, &block|
					klass.instance_eval {
						stitcher_require sig
						define_method name, &block
					}
				}
			}
		end
	end

end
