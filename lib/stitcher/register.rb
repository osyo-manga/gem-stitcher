require_relative "./core_ext"
require_relative "./register"

using StitcherArrayEx


class UnboundMethod
	alias_method :stitcher_bind, :bind
end


module Stitcher module Register
	def self.define_call_method self_, name
		self_.__send__ :define_method, name do |*args, &block|
# 			_, method = mtable.find{|sig, _| sig == args.map(&:class) } || mtable.find {|sig, _| sig === args}
			method = self_.stitcher_method_detecting name, *args, &block

			return super(*args, &block) unless method
			method = method.stitcher_bind(self) if method.respond_to? :stitcher_bind
			method.call *args, &block
		end
	end

	def self.register self_, name, sig = nil, method = self_.instance_method(name)
		self_.stitcher_add name, sig, method
		Register.define_call_method self_, name
	end

	def stitcher_register name, sig, &block
		Register.register(self, name, sig, block_given? ? block : instance_method(name))
	end
end end
