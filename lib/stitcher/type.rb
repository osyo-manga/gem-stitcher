module Stitcher
	module TypeOperators
		def | other
			Stitcher.type_or self, other
		end

		def & other
			Stitcher.type_and self, other
		end

		def !
			Stitcher.type_not self
		end

		def +@
			Stitcher.type_plus_at self
		end
	end
end


module Stitcher module Refinements
	module Type
		refine Object do
			def type
				stitcher_type
			end

			def stitcher_type
				Stitcher::Type.new self.class == Class ? self : self.class
			end

			def classtype
				self.class == Class ? self : self.class
			end
		end

		refine Class do
			include TypeOperators
		end
	end
end end


using Stitcher::Refinements::Type


module Stitcher
	class Type
		include TypeOperators

		def initialize klass = nil, &block
			@comp = block
			@comp = lambda do |other, op|
				# change operator "<" to ">".
				return other.comp(klass, op.to_s.tr("<>", "><"))  if other.class == Type
				return self.comp(klass, :===) if op.to_sym == :===
				klass.__send__ op, other.classtype
			end unless block_given?
		end

		def comp other, op
			!!@comp.(other, op)
		end

		[:==, :!=, :>=, :<=, :>, :<, :===].each do |op|
			define_method(op) do |other|
				comp other, op
			end
		end

		def type
			self
		end
	end

	def type_or a, b
		Type.new do |other, op|
			(a.type.__send__ op, other.type) || (b.type.__send__ op, other.type)
		end
	end
	module_function :type_or


	def type_and a, b
		Type.new do |other, op|
			(a.type.__send__ op, other.type) && (b.type.__send__ op, other.type)
		end
	end
	module_function :type_and

	def type_not a
		Type.new do |other, op|
			!(a.type.__send__ op, other.type)
		end
	end
	module_function :type_not

	def type_plus_at a
		Type.new do |other, op|
			next a.type >= other if op.to_sym == :===
			a.type.__send__ op, other.type
		end
	end
	module_function :type_plus_at
end

