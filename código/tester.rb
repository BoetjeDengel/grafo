require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'
require_relative 'grafo_utils'

class Tester
	include ConstructoresDeGrafo

	def ftia
		decorador = Decoradores.valor
		dotador = Dotador.new(decorador)
	#	dotador = DotadorNoHijos.new(decorador)
		layouts = [:dot, :twopi]
		grafo = test_cadenas_same_length
		grafo.export_png('test_cadenas_same_length', dotador, layouts)
#		grafo
	end
end