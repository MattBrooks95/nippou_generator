require_relative 'Nippou'

class NippouGenerator
	def getNippou(firstName='first',lastName='last', shortName = nil, ps = '')
		nippou = Nippou.new(firstName, lastName, ps)
		return nippou
	end
end
