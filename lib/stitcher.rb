require_relative "./stitcher/version"
require_relative "./stitcher/core"

module Stitcher
	include Core

	refine Module do
		include Core
	end
end
