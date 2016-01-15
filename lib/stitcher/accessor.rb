require_relative "./register"

using Stitcher

module Stitcher module Accessor
	include Register

	def stitcher_writer **opt
		opt.each { |name, type|
			Register.stitcher_register(self, "#{name}=", [type]) do |var|
				instance_variable_set "@#{name}", var
			end
# 			stitcher_register "#{name}=", [type] do |var|
# 				instance_variable_set "@#{name}", var
# 			end
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		Accessor.instance_method(:stitcher_writer).bind(self).(opt)
# 		stitcher_writer opt
	end
end end
