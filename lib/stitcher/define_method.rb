require_relative "./register"
require_relative "./accessor"

module Stitcher module DefineMethod
	include Stitcher::Register
	include Stitcher::Accessor

	def stitcher_define_method name, **opt, &block
		stitcher_register name, opt.values do |*args|
			self_ = self
			obj = Object.new
			obj.extend(Module.new{
				private
				attr_reader *opt.keys
			})
			obj.instance_eval do
				opt.each_with_index { |data, index|
					name, type = data
					instance_variable_set "@#{name}", args[index]
				}
				define_singleton_method :method_missing do |name, *args, &block|
					self_.__send__ name, *args, &block
				end

				instance_eval &block
			end
		end
	end

end end
