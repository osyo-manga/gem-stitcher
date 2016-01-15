module Stitcher
	module ClassOperators
		def | other
			proc { |it| self === it || other === it  }
		end

		def & other
			proc { |it| self === it && other === it  }
		end

		def !
			proc { |other| !(self === other)  }
		end

		refine Class do
			include ClassOperators
		end
	end
end


