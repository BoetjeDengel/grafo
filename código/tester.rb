require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'
require_relative 'grafo_utils'

class Tester
	include Constructores

	def ftia
		decorador = Decoradores.valor
#		decorador = Decoradores.valor_no_border_no_arrowhead
		dotador = Dotador.new(decorador)
	#	dotador = DotadorNoHijos.new(decorador)
		layouts = [:dot]

		rejemplos.map(&:method).each_with_index do |method, index|
			public_send(method).export_png("#{index}_#{method}", dotador, layouts)
		end
	end
end