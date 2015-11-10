require_relative './spec_helper'


using Stitcher::Refinements::Type


describe Stitcher::Type do
	it "Object#type" do
		expect(1.type.class == Stitcher::Type).to eq true
	end
	it "#type" do
		expect(1.type.type.class == Stitcher::Type).to eq true
		expect(1.type.class == Stitcher::Type).to eq true
	end
	describe "operators" do
		describe "compare" do
			describe "#==" do
				it "Class" do
					expect(1.type == Fixnum).to eq true
					expect(1.type == Numeric).to eq false
				end
				it "Type" do
					expect(1.type == Stitcher::Type).to eq false
				end
				it "other object" do
					expect(1.type == 1).to eq true
					expect(1.type == Fixnum.type).to eq true
				end
			end
			it "#!=" do
				expect(1.type != Numeric).to eq true
			end
			it "#<" do
				expect(1.type < Numeric).to eq true
				expect(1.type < Fixnum).to eq false
				expect(1.type < Numeric.type).to eq true
			end
			it "#<=" do
				expect(1.type <= Numeric).to eq true
				expect(1.type <= Fixnum).to eq true
				expect(1.type <= Fixnum.type).to eq true
			end
			it "#>" do
				expect(Numeric.type > 1).to eq true
				expect(Fixnum.type > 1).to eq false
				expect(Numeric.type > 1.type).to eq true
			end
		end
		describe "or" do
			let(:type){ Numeric.type | String | Float }
			it "type_or == type" do
				expect(type == "").to eq true
				expect(type == 1).to eq false
				expect(type == 1.0).to eq true
				expect(type == []).to eq false
			end
			it "type == type" do
				expect("".type  == type).to eq true
				expect(1.type   == type).to eq false
				expect(1.0.type == type).to eq true
				expect(type == []).to eq false
			end
			it "type_or == type_or" do
				expect(type == Stitcher.type_or("", [])).to eq true
				expect(type == Stitcher.type_or("", 1.0)).to eq true
				expect(type == Stitcher.type_or(1, [])).to eq false
				expect(type == Stitcher.type_or([], [])).to eq false
			end
			it "type_or <= type" do
				expect(type <= 0).to eq false
				expect(type <= 0.type).to eq false
			end
			it "type_or >= type" do
				expect(type >= 0).to eq true
				expect(type >= 0.type).to eq true
			end
		end
		describe "not" do
			it "!type" do
				expect(!String.type == "").to eq false
				expect(!String.type == 0).to eq true
				expect(!Numeric.type >= 0).to eq false
			end
		end
		describe "and" do
			it "==" do
				expect((!String.type & Fixnum) == "").to eq false
				expect((!String.type & Fixnum) == 0).to eq true
			end
			let(:type){ Numeric.type & !Fixnum }
			it "<=" do
				expect(0.type <= type).to eq false
				expect(0.0.type <= type).to eq true
			end
		end
	end
end
