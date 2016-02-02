require_relative "./core_ext"

using StitcherArrayEx

module Stitcher
	module Operators
		def self.require_other other
			Proc === other || Class === other
		end

		def & other
			return super(other) unless Operators.require_other other
			proc { |it, &block| self.===(it, &block) && other.===(it, &block)  }
		end

		def | other
			return super(other) unless Operators.require_other other
			proc { |it, &block| self.===(it, &block) || other.===(it, &block)  }
		end

		def !
			proc { |it, &block| !(self.===(it, &block)) }
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
	end
end
