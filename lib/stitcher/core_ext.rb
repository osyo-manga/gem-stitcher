module StitcherArrayEx
	refine Array do
		def === other
			map.with_index do |it, index|
				it <=> other[index]
			end
# 			return false if length != other.length
# 			each_with_index do |it, index|
# 				return false unless it === other[index]
# 			end
# 			true
		end
	end
end
