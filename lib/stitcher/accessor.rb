require_relative "../stitcher"
require_relative "./stitch"

using Stitcher

module Stitcher module Accessor
	include Stitcher::Stitch

	def stitcher_writer **opt
		opt.each { |name, type|
			stitch "#{name}=", [type] do |var|
				instance_variable_set "@#{name}", var
			end
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		stitcher_writer opt
	end
end end
