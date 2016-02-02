require_relative './spec_helper'

using Stitcher::Operators

describe "Stitcher" do
	describe "And" do
		it "success" do
			expect( (Object & !Fixnum) === [] ).to eq true
			expect( (Object & !Fixnum) === [] ).to eq true
		end
	end
end

