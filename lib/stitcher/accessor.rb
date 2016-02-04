require_relative "./register"
require_relative "./define_method"

using Stitcher

module Stitcher module Accessor
	include Register

	def stitcher_writer **opt
		opt.each { |name, type|
			Register.register(self, "#{name}=", [type], (DefineMethod.as_instance_executable do |var|
				instance_variable_set "@#{name}", var
			end))
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		Accessor.instance_method(:stitcher_writer).bind(self).(opt)
	end
end end
