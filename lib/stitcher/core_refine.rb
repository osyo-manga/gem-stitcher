module Stitcher module Refine
	module ProcUnbind
		refine Proc do
			def unbind
				self_ = self
				Module.new {
					define_method :unbound_method, &self_
				}.instance_method(:unbound_method)
			end

			def rebind obj
				unbind.bind obj
			end
		end
	end
end end
