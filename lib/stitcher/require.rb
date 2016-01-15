require_relative "./register"

module Stitcher module Require
	include 
	def stitcher_require concept
		@concept = concept
		return if methods.include? :method_added
		def self.method_added name
			return unless @concept
			concept = @concept
			@concept = nil
			Register.stitcher_register self, name, concept
		end
	end
end end
