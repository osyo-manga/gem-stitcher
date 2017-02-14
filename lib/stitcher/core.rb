require_relative "./core_refine"
require "laurel"
require "unmixer"

using Stitcher::Refine::ProcUnbind
using Unmixer

module Stitcher module Core
	using Module.new {
		refine Array do
			def === other, &block
				size == other.size && zip(other).all? { |a, b| a.=== b, &block }
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


	def stitcher_define_method sig, name, &block
		Core.bind(self).stitcher_register sig, name, block.unbind
	end

	def stitcher_def
		Laurel.proxy { |name, **sig, &block|
			instance_eval {
				Core.bind(self).stitcher_define_method sig.values, name do |*args, &block_|
					extend(Module.new {
						sig.keys.each_with_index { |name, i| private define_method(name){ args[i] } }
					}) { |self_|
						break block.rebind(self_).call &block_
					}
				end
			}
		}
	end

	def stitcher_require sig
		mod = Module.new {
			define_method :method_added { |name|
				singleton_class.instance_eval { unprepend(mod) }
				Core.bind(self).stitcher_register sig, name
			}
		}
		singleton_class.prepend(mod)
	end

	def stitcher_writer **opt
		opt.each { |name, type|
			Core.bind(self).stitcher_define_method([type], "#{name}="){ |var|
				instance_variable_set "@#{name}", var
			}
		}
	end

	def stitcher_accessor **opt
		attr_reader *opt.keys
		Core.bind(self).stitcher_writer opt
	end
end end
