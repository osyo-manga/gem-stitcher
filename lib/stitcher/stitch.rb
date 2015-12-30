require_relative "./core_ext"

using StitcherArrayEx


module Stitcher module Stitch
	def stitcher_stitch_method_table name
		instance_eval { @stitcher_stitch_method_table ||= {}; @stitcher_stitch_method_table[name] ||= {} }
	end

	def stitch name, sig, &block
		if !block_given?
			mem = instance_method(name)
			return stitch(name, sig, &proc { |*args| mem.bind(self).call *args })
		end
		stitcher_stitch_method_table(name)[sig] = block
		self_ = self
		
		define_method name do |*args|
			_, method = self_.stitcher_stitch_method_table(name).find {|sig, _| sig === args}
			return super(*args) unless method
			instance_exec *args, &method
		end
	end
end end
