module StitcherArrayEx
	refine Array do
		def === other
			size == other.size && zip(other).all? { |a, b| a === b }
		end
	end
end
