require_relative "../type"

class Object
	def type
		stitcher_type
	end

	def stitcher_type
		Stitcher::Type.new self.class == Class ? self : self.class
	end
end
