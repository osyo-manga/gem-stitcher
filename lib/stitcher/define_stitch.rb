require_relative "./stitch.rb"
require_relative "./accessor.rb"

module Stitcher module DefineStitch
	include Stitcher::Stitch
	include Stitcher::Accessor

	def define_stitch name, **opt, &block
		stitch name, opt.values do |*args|
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
