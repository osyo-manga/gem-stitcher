require_relative "./register"
# require_relative "../stitcher"


module Stitcher module Require
	include Register

	def stitcher_require concept
		@stitcher_require_concept = concept
		@stitcher_require_methods = instance_methods.map { |name| instance_method name }

		return if methods.include? :method_added
		def self.method_added name
			return unless @stitcher_require_concept
			concept = @stitcher_require_concept
			@stitcher_require_concept = nil

			method = @stitcher_require_methods.find{ |it| it.name == name }
			if method && stitcher_method_table(name).empty?
				# Don't wrap method.
				stitcher_add name, nil, method
			end

			Register.register self, name, concept
		end
	end
end end
