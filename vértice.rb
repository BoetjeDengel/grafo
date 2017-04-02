
class Vértice

	attr_reader :valor, :index

	def initialize(padres, razón, valor, index)
		@padres = padres
		padres.each do |padre|
			padre.añada_hijo(self)
		end
		@razón = razón
		@valor = valor
		@index = index
#		@hermanos =[]
#		@hermotros = []
		@hijos = []
	end

	def to_dot(decorador)
		"#{index}[#{decorador.decan(self)}]"
	end

	def es_raíz?
		@padres.empty?
	end

	def tiene_hijos
		@hijos.empty?
	end

	def añada_hijo(vértice)
		@hijos << vértice
	end

	def cuantos_hijos_tiene
		@hijos.size
	end

end