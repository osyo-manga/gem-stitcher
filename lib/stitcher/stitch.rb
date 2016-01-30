require_relative "./register"
require_relative "./define_method"

module Stitcher module Stitch
	include Register
	include DefineMethod

	class Definer < BasicObject
		def initialize obj
			@obj = obj
		end

		def method_missing name, sig, &block
			DefineMethod.instance_method(:stitcher_define_method).bind(@obj).(name, sig, &block)
		end
	end

	def stitch *args, &block
		return Definer.new self if args.empty?
		Register.register self, *args, &block
	end
end end
