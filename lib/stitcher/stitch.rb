require_relative "./register"
require_relative "./define_method"

module Stitcher module Stitch
	include Stitcher::Register
	include Stitcher::DefineMethod

	def stitch *args, &block
		return stitcher_register *args, &block unless args.empty?
		self_ = self
		Class.new do |klass|
			define_singleton_method(:method_missing) do |name, sig, &block|
				self_.stitcher_define_method name, sig, &block
			end
		end
	end
end end
