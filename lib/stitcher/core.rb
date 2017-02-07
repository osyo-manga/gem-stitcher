module Stitcher module Core
	using Module.new {
		refine Array do
			def === other
				size == other.size && zip(other).all? { |a, b| a === b }
			end
		end
	}

	def self.bind obj
		mod = self
		Class.new(BasicObject) {
			define_method :method_missing do |name, *args, &block|
				mod.instance_method(name).bind(obj).call *args, &block
			end
		}.new
	end

	def stitcher_method_table
		@stitcher_method_table ||= Hash.new { |hash, key| hash[key] = [] }
	end

	def stitcher_register sig, name, imethod = instance_method(name)
		methods = Core.bind(self).stitcher_method_table[name]
		methods.unshift [sig, imethod]
		define_method name do |*args, &block|
			_, imethod = methods.find {|sig, _| sig.=== args, &block }
			return super(*args, &block) unless imethod

			imethod.bind(self).call *args, &block
		end
	end
end end
