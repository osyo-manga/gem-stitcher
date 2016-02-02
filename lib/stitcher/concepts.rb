module Stitcher module Concepts
	def blockable
		proc { |*args, &block| !!block }
	end
	module_function :blockable
end end
