
require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'

def ftiax(  args: [],
			grafo: ConstructoresDeGrafo.ej1b(10),
			decorador: Decoradores.color("blues"),
			layout: [:dot, :twopi]	)
	dotador = Dotador.new(decorador)
	grafo.export_png('spawn', dotador, layout)
#	live = ExportadorDirecto.new(grafo)
end


def ftiaxe(raíces)
	grafo = Grafo.new
	decorador = Decoradores.color_si_tiene_hijos
	dotador = Dotador.new(decorador)
	layouts = [:twopi]
	live = ExportadorDirecto.new(grafo, dotador, layouts)
	ConstructoresDeGrafo.ej4cg(grafo, 10, raíces)
	true

#	grafo.export_png('spawn', dotador, layout)
#	
end