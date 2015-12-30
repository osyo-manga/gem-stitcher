require_relative "./register"

using Stitcher

module Stitcher module Accessor
	include Stitcher::Register

	def stitcher_writer **opt
		opt.each { |name, type|
			stitcher_register "#{name}=", [type] do |var|
				instance_variable_set "@#{name}", var
			end
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		stitcher_writer opt
	end
end end
