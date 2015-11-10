require_relative './spec_helper'
require_relative "./stitcher_spec_type.rb"

class X
	include Stitcher

	def m a
		1
	end
	concept :m do |a|
		a.class <= Numeric
	end

	def m a
		2
	end
	concept :m do |a|
		a.class <= String
	end
end

describe Stitcher do
	it 'has a version number' do
		expect(Stitcher::VERSION).not_to be nil
	end

	describe "in concept" do
		x = X.new
		it 'X#m(Numeric) to 1' do
			expect(x.m 1).to eq 1
		end
		it 'X#m(String) to 2' do
			expect(x.m "").to eq 2
		end
	end
end
