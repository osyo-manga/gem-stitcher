module StitcherArrayEx
	refine Array do
		def === other
			return false if length != other.length
			each_with_index do |it, index|
				return false unless it === other[index]
			end
			true
		end
	end
end
