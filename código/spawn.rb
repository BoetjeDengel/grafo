
require_relative 'constructores'
require_relative 'decoradores'
require_relative 'dotador'
require_relative 'exportable'
require_relative 'grafo'
require_relative 'grafo_utils'

def ftiax(  args: [],
			grafo: Grafo.new,
			decorador: Decoradores.valor,
			layout: [:dot]	)

			valor_de_raíz = 13
			rs = {:raíz => [valor_de_raíz]}
			ld = lambda { |padre| {:m => [padre.valor-1]} }
			lt = lambda { |n| n.valor <= 0 }

	p = ConstructoresDeGrafo::MétodoCadena.método1(rs,ld,lt)


	#(&ConstructoresDeGrafo::método1)
#	dotador = Dotador.new(decorador)
#	grafo.export_png('spawn', dotador, layout)
#	live = ExportadorDirecto.new(grafo)
end


def ftiaxe(*args)
	decorador = Decoradores.n_de_hijos_color()
#	dotador = Dotador.new(decorador)
	dotador = DotadorNoHijos.new(decorador)
	layouts = [:dot, :twopi]
	grafo = ConstructoresDeGrafo.métodoR(*args)
	grafo.export_png('spawn', dotador, layouts)
	grafo

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