require_relative "./core_ext"
require_relative "./register"
require_relative "./variadic_argument"

module StitcherArrayEx
	refine Array do
		include Stitcher::VariadicArgument
	end
end
using StitcherArrayEx


module Stitcher module Register
	def self.stitcher_method_table self_, name
		self_.instance_eval { @stitcher_method_table ||= {}; @stitcher_method_table[name] ||= {} }
	end

	def self.stitcher_add_for_method self_, mem, sig = nil
		sig = (mem.arity < 0 ? +([Object] * mem.arity.abs) : [Object] * mem.arity.abs) unless sig
		name = mem.name
		Register.stitcher_method_table(self_, name)[sig] = proc { |*args|
			block = args.pop
			if block
				mem.bind(self).call *args, &block
			else
				mem.bind(self).call *args
			end
		}
	end

	def self.stitcher_register self_, name, sig, &block
		if block_given?
			Register.stitcher_method_table(self_, name)[sig] = block
		else
			mem = self_.instance_method(name)
			Register.stitcher_add_for_method self_, mem, sig
		end
		
		self_.__send__ :define_method, name do |*args, &block|
			_, method = Register.stitcher_method_table(self_, name).to_a.reverse.find {|sig, _| sig === args}
			return super(*args, &block) unless method
			instance_exec *args + [block], &method
		end
	end

	def stitcher_register name, sig, &block
		Register.stitcher_register(self, name, sig, &block)
	end
end end
