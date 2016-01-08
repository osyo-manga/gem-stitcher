require_relative "./stitcher/version"
# require_relative "./stitcher/type"
require_relative "./stitcher/define_method"
require_relative "./stitcher/accessor"
require_relative "./stitcher/stitch"

module Stitcher
	include Register
	include Accessor
	include Stitch
	include DefineMethod

	refine Module do
		include Stitcher
# 		Stitcher.instance_methods.each do |name|
# 			alias_method name, name
# 		end
	end
end
