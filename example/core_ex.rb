# original source code
# http://melborne.github.io/2013/08/30/monkey-patching-for-prudent-rubyists/
require "stitcher"

using Stitcher

class Array
	stitcher_require +[Fixnum, Fixnum]
	def at *indices
		at(indices.shift).at(*indices)
	end
end

p [1,2,3].at(1)
# => 1
p [[1,2,3], [4,5,6], [7,8,9]].at(1, 2)
# => 6
p [
    [[1,2,3],[4,5,6],[7,8,9]],
    [[10,11,12],[13,14,15],[16,17,18]],
    [[19,20,21],[22,23,24],[25,26,27]]
].at(1, 2, 0)
# => 16
