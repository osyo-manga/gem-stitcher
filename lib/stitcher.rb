require_relative "./stitcher/version"
# require_relative "./stitcher/type"
require_relative "./stitcher/define_method"
require_relative "./stitcher/accessor"
require_relative "./stitcher/stitch"
require_relative "./stitcher/class_operator"
require_relative "./stitcher/require"
require_relative "./stitcher/variadic_argument"

module Stitcher
	include Accessor
	include Stitch
	include Require

	refine Module do
		include Stitcher
	end

	refine Class do
		include ClassOperators
	end

	refine Array do
		include VariadicArgument
	end
end
