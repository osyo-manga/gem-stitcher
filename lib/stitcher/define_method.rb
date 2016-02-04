require_relative "./register"
require_relative "./accessor"


module Stitcher module DefineMethod
	include Stitcher::Register

	def self.as_instance_executable &block
		Object.new.instance_eval do
			define_singleton_method :stitcher_bind do |obj|
				proc do |*args, &block_|
					self_ = obj
					self_.instance_exec *args, block, &block
				end
			end
			self
		end
	end

	def stitcher_define_method name, **opt, &block
		obj = DefineMethod.as_instance_executable do |*args|
			_ = args.pop		# block object
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

# 				define_singleton_method :[] do |name|
# 					self_.instance_eval "@#{ name }"
# 				end
#
# 				define_singleton_method :[]= do |name, var|
# 					obj.instance_eval { self_.instance_variable_set "@#{name}", var }
# 				end
				
				define_singleton_method :method_missing do |name, *args, &block|
					self_.__send__ name, *args, &block
				end

				instance_eval &block
			end
		end
		Register.register self, name, opt.values, obj
	end
end end
