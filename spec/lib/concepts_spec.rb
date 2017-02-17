require_relative '../spec_helper'

describe Stitcher::Concepts do
	context ".blockable" do
		include Stitcher::Concepts
		context "block を渡した場合" do
			subject { blockable.call {} }
			it { is_expected.to be true }
			it { is_expected.to be_kind_of TrueClass }
		end

		context "block を渡さなかった場合" do
			subject { blockable.call }
			it { is_expected.to be false }
			it { is_expected.to be_kind_of FalseClass }
		end

	end
end
