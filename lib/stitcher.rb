require_relative "./stitcher/version"
# require_relative "./stitcher/type"
require_relative "./stitcher/core_ext"


using StitcherArrayEx


module Stitcher
	def stitcher_concept_method_table name
		instance_eval { @stitcher_concept_method_table ||= {}; @stitcher_concept_method_table[name] ||= {} }
	end

	def stitcher_register name, sig, &block
		if !block_given?
			mem = instance_method(name)
			return stitcher_register(name, sig, &proc { |*args| mem.bind(self).call *args })
		end
		stitcher_concept_method_table(name)[sig] = block
		self_ = self
		
		define_method name do |*args|
			_, method = self_.stitcher_concept_method_table(name).find {|sig, _| sig === args}
			return super(*args) unless method
			instance_exec *args, &method
		end
	end

	def stitcher_writer **opt
		opt.each { |name, type|
			define_method "#{name}=" do |var|
				raise "No match type." unless type === var
				instance_variable_set "@#{name}", var
			end
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		stitcher_writer opt
	end

	def stitcher_define_method name, **opt, &block
		stitcher_register name, opt.values do |*args|
			self_ = self
			obj = Object.new
			obj.extend(Module.new{
				extend Stitcher
				stitcher_accessor opt
			})
			obj.instance_eval do
				opt.each_with_index { |data, index|
					name, type = data
					__send__ "#{name}=", args[index]
				}
				define_singleton_method :method_missing do |name, *args, &block|
					self_.__send__ name, *args, &block
				end

				instance_eval &block
			end
		end
	end
end

