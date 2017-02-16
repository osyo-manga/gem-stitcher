require "stitcher"

using Stitcher

class X
	stitcher_require [Object]
	def get url
		"http"
	end

	stitcher_require [/^https/]
	def get url
		"https"
	end
end


x = X.new
p x.get "https://twitter.com/"
p x.get "http://lingr.com/"
