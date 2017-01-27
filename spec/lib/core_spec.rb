require_relative '../spec_helper'

using Module.new {
	refine Module do
		include Stitcher::Core
	end
}

describe Stitcher::Core do
	describe "#stitcher_register" do
		subject {
			Object.new.instance_eval {
				def call a, b
					"Integer, Integer"
				end
				self
			}
		}
# 		it_behaves_like "OK"
	end
end
