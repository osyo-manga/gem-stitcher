require_relative "./core_ext"

using StitcherArrayEx

module Stitcher module VariadicArgument
	def +@
		lambda { |other|
			return false if size > other.size
			clone.fill(last, size, other.size - size) === other
		}
	end
end end
