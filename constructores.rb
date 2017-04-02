
require_relative 'decoradores'
require_relative 'grafo'

class ConstructoresDeGrafo

	def self.método1(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		to_be_developed = grafo.añada_raíces(hash_de_raíces)
		while ! to_be_developed.empty?
			padres = to_be_developed
			to_be_developed = []
			padres.each do |padre|
				if ! lambda_terminal.(padre)			
					vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
					to_be_developed.concat(vértices_nuevos)
				end
			end			
		end
		grafo
	end

	def self.cadena(valor_de_raíz)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1]} }
		self.método1(rs,ld,lt)
	end

	def self.ej1
		rs = {:raíz => [10,20]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método1(rs,ld,lt)
	end

	def self.ej1a(valor_de_raíz, hijos)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(hijos)).times.collect { rand(padre.valor) } } }
		self.método1(rs,ld,lt)
	end

	def self.método1b(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		to_be_developed = grafo.añada_raíces(hash_de_raíces)
		while ! to_be_developed.empty?
			padres = to_be_developed
			to_be_developed = []
			padres.each do |padre|
				if ! lambda_terminal.(padre)			
					vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
					to_be_developed.concat(vértices_nuevos)
				end
			end			
		end
		grafo
	end

	def self.ej1b(valor_de_raíz)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(padre.valor)).times.collect { rand(padre.valor) } } }
		self.método1b(rs,ld,lt)
	end

	def self.método_no_lt(hash_de_raíces, lambda_de_desarollo)
		grafo = Grafo.new
		to_be_developed = grafo.añada_raíces(hash_de_raíces)
		while ! to_be_developed.empty?
			padres = to_be_developed
			to_be_developed = []
			padres.each do |padre|
				vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
				to_be_developed.concat(vértices_nuevos)
			end			
		end
		grafo
	end

	def self.ej_no_lt(valor_de_raíz)
		rs = {:raíz => [valor_de_raíz]}
		ld = lambda { |padre| {:m => rand(padre.valor+1).times.collect { rand(padre.valor) } } }
		self.método_no_lt(rs,ld)
	end

	def self.método2(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		vértices = grafo.añada_raíces(hash_de_raíces)
		while ! vértices.empty?
			particiones = vértices.group_by { |vértice| vértice.valor }
			vértices = []
			particiones.each_value do |padres|
				if ! lambda_terminal.(padres[0])						
					vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres[0]))
					vértices.concat(vértices_nuevos)
				end
			end
		end
		grafo
	end

	def self.ej2
		rs = {:raíz => [10,11,12,13]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método2(rs,ld,lt)
	end

	def self.método3(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		vértices = grafo.añada_raíces(hash_de_raíces)
		padres = vértices
		vértices = []
		padres.each do |padre|
			vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
			vértices.concat(vértices_nuevos)
		end
		while vértices.count > 1
			particiones = vértices.group_by { |vértice| vértice.valor }
			padres = particiones.max[1]
			padres.each { |p| vértices.delete(p) }
			if ! lambda_terminal.(padres[0])						
				vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres[0]))
				vértices.concat(vértices_nuevos)
			end
		end
		grafo
	end

	def self.ej3(step,número_de_raíces)
		rs = {:raíz => número_de_raíces.times.collect { 100 }}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor-step...padre.valor)]} }
		self.método3(rs,ld,lt)
	end

	def self.método4(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		vértices = grafo.añada_raíces(hash_de_raíces)
		padres = vértices
		vértices = []
		padres.each do |padre|
			vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
			vértices.concat(vértices_nuevos)
		end
		while vértices.count > 1
			particiones = vértices.group_by { |vértice| vértice.valor }
			padres = particiones.max[1]
			padres.each { |p| vértices.delete(p) }
			if ! lambda_terminal.(padres[0])						
				vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres[0]))
				vértices.concat(vértices_nuevos)
			end
		end
		grafo
	end

	def self.ej4(step,número_de_raíces)
		rs = {:raíz => número_de_raíces.times.collect { 100 }}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor-step...padre.valor)]} }
		self.método4(rs,ld,lt)
	end


end

=begin
class S

	def initialize(number)
		@number = number
	end

	def to_s
		@number.to_s
	end

	def terminal?
		 @number <= 0
	end

	def spawn
		S.new(@number-1) if ! terminal?
	end

end
=end