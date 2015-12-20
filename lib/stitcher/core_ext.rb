module StitcherArrayEx
	refine Array do
		def === other
			each_with_index do |it, index|
				return false unless it === other[index]
			end
			true
		end
	end
end
