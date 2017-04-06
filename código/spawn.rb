
require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'

def ftiax(  args: [],
			grafo: Grafo.new,
			decorador: Decoradores.valor,
			layout: [:dot]	)

			valor_de_raíz = 13
			rs = {:raíz => [valor_de_raíz]}
			lt = lambda { |n| n.valor <= 0 }
			ld = lambda { |padre| {:m => [padre.valor-1]} }
	p = ConstructoresDeGrafo::método1(rs,ld,lt)

	grafo.desarrollar p


	#(&ConstructoresDeGrafo::método1)
	dotador = Dotador.new(decorador)
	grafo.export_png('spawn', dotador, layout)
#	live = ExportadorDirecto.new(grafo)
end


def ftiaxe
	grafo = Grafo.new
	decorador = Decoradores.color_si_tiene_hijos
	dotador = Dotador.new(decorador)
	layouts = [:dot]
	live = ExportadorDirecto.new(grafo, dotador, layouts)
	ConstructoresDeGrafo.ejSimp1(grafo, 50, 1000)
	true

#	grafo.export_png('spawn', dotador, layout)
#	
end

def ftiaxe2(raíces)
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