require_relative "./variadic_argument"

module StitcherArrayEx
	refine Array do
		include Stitcher::VariadicArgument
	end
end
using StitcherArrayEx

module Stitcher module Core
	def stitcher_method_table name
		instance_eval { @stitcher_method_table ||= {}; @stitcher_method_table[name] ||= [] }
	end
	
	def stitcher_method_table_all name
		mtable = stitcher_method_table(name) unless superclass
		return stitcher_method_table_all(superclass, name).merge(mtable) if superclass
		mtable
	end

	def stitcher_add name, sig, method
		sig = (method.arity < 0 ? +([Object] * method.arity.abs) : [Object] * method.arity.abs) unless sig
		stitcher_method_table(name) << [sig, method]
	end

	def stitcher_method_detecting name, *args, &block
		mtable = stitcher_method_table(name).to_a.reverse
		_, method = mtable.find {|sig, _| sig.=== args, &block }
		method
	end
end end
