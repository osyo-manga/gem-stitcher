require_relative './spec_helper'

using Stitcher

class X
	stitcher_accessor name: String, age: Numeric
end


describe "Stitcher::Accessor" do
	x = X.new
end
