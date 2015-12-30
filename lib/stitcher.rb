require_relative "./stitcher/version"
# require_relative "./stitcher/type"
require_relative "./stitcher/define_stitch"
require_relative "./stitcher/accessor"

module Stitcher
	include Accessor
	include DefineStitch
end
