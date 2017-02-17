module Stitcher module Concepts
	module_function
	def blockable
		proc { |*args, &block| !!block }
	end
end end
