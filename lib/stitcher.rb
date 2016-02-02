require_relative "./stitcher/version"
# require_relative "./stitcher/type"
require_relative "./stitcher/define_method"
require_relative "./stitcher/accessor"
require_relative "./stitcher/stitch"
require_relative "./stitcher/operators"
require_relative "./stitcher/require"
require_relative "./stitcher/variadic_argument"
require_relative "./stitcher/core"
require_relative "./stitcher/concepts"

module Stitcher
	include Accessor
	include Stitch
	include Require

	refine Module do
		include Stitcher
	end

	refine Class do
		prepend Operators
	end

	refine Array do
		prepend Operators
	end

	refine Proc do
		prepend Operators
	end

	refine Array do
		include VariadicArgument
	end
end

class Module
	include Stitcher::Core
end
