require_relative "./core_ext"

using StitcherArrayEx


module Stitcher module Register
	def self.stitcher_method_table self_, name
		self_.instance_eval { @stitcher_method_table ||= {}; @stitcher_method_table[name] ||= {} }
	end

	def self.stitcher_register self_, name, sig, &block
		if !block_given?
			mem = self_.instance_method(name)
			return Register.stitcher_register(self_, name, sig, &proc { |*args| mem.bind(self).call *args })
		end
		Register.stitcher_method_table(self_, name)[sig] = block
		
		self_.send :define_method, name do |*args|
			_, method = Register.stitcher_method_table(self_, name).find {|sig, _| sig === args}
			return super(*args) unless method
			instance_exec *args, &method
		end
	end

	def stitcher_register name, sig, &block
		Register.stitcher_register(self, name, sig, &block)
	end
end end
