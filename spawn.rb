
require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'

def ftiax( 
			grafo: ConstructoresDeGrafo.cadena(5),
			decorador: Decoradores.valor,
			layout: :twopi	)
	dotador = Dotador.new(decorador)
	grafo.export_png('spawn',dotador, layout)
	live = ExportadorDirecto.new(grafo)
end

#load('constructores.rb');load('decoradores.rb');load('dotador.rb');load('exportable.rb');load('grafo.rb');load('spawn.rb')