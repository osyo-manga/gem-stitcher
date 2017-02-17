require_relative "./stitcher/version"
require_relative "./stitcher/core"
require_relative "./stitcher/concepts"

module Stitcher
	include Core

	refine Module do
		include Core
	end
end
