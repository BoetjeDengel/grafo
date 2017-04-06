
require_relative 'grafo'

module ConstructoresDeGrafo


	class Ejemplo
	
		attr_reader :proc, :description

		def initialize(proc, description)
			@proc = proc
#			@hash = hash
			@description = description
		end
	end

	class MétodoCadena

		def self.proc(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
			Proc.new do |grafo|
				to_be_developed = grafo.añada_raíces(hash_de_raíces)
				while ! to_be_developed.empty?
					padres = to_be_developed
					to_be_developed = padres.inject([]) do |acc, padre|
						if ! lambda_terminal.(padre)			
							vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))
							acc.concat(vértices_nuevos)
						end
					end			
				end
				grafo
			end
		end


		def self.ejemplos
			ejemplos = []

			ejemplos << Ejemplo.new(
				proc(
					{ :raíz => [9] },
					lambda { |padre| { :m => [padre.valor-1]} },
					lambda { |vértice| vértice.valor <= 0 }
				),
				"Αλυσίδα με τιμή κατά ένα μικρότερη του πατέρα. Αρχίζει από το όρισμα και σταματάει στο 0."
			)
		end

		#valor_de_raíz => 10,
#			:hash_de_raíces => { :raíz => [valor_de_raíz] },
#			:lambda_de_desarollo => lambda { |padre| { :m => [padre.valor-1]} },
#			:lambda_terminal => lambda { |vértice| vértice.valor <= 0 }
#			)
#				"Αλυσίδα με τυχαία τιμή μικρότερη του πατέρα. Αρχίζει από το όρισμα και σταματάει στο 0."
#			)
#
#
#			valor_de_raíz => 10,
#			:hash_de_raíces => { :raíz => [valor_de_raíz] },
#			:lambda_de_desarollo => lambda { |padre| { :m => [padre.valor-1]} },
#			:lambda_terminal => lambda { |vértice| vértice.valor <= 0 }
#			)
		
		def rand_valor
			rs = {:raíz => [10,20]}
			lt = lambda { |n| n.valor <= 0 }
			ld = lambda { |padre| {:m => [rand(padre.valor)]} }
			método1(rs,ld,lt)
		end

		def ej1a(valor_de_raíz, hijos)
			rs = {:raíz => [valor_de_raíz]}
			lt = lambda { |n| n.valor <= 0 }
			ld = lambda { |padre| {:m => (1+rand(hijos)).times.collect { rand(padre.valor) } } }
			método1(rs,ld,lt)
		end
	end

	def método1b(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
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

	def ej1b(valor_de_raíz)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(padre.valor)).times.collect { rand(padre.valor) } } }
		método1b(rs,ld,lt)
	end

	def método_no_lt(hash_de_raíces, lambda_de_desarollo)
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

	def ej_no_lt(valor_de_raíz)
		rs = {:raíz => [valor_de_raíz]}
		ld = lambda { |padre| {:m => rand(padre.valor+1).times.collect { rand(padre.valor) } } }
		método_no_lt(rs,ld)
	end

	def método2(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
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

	def ej2
		rs = {:raíz => [10,11,12,13]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		método2(rs,ld,lt)
	end

	def método3(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
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

	def ej3(valor_inicial, número_de_raíces, step)
		rs = {:raíz => número_de_raíces.times.collect { valor_inicial }}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor-step...padre.valor)]} }
		método3(rs,ld,lt)
	end

	def método4(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		grafo.live
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

	def ej4(step,número_de_raíces)
		rs = {:raíz => número_de_raíces.times.collect { 100 }}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor-step...padre.valor)]} }
		método4(rs,ld,lt)
	end

	def método4congrafo(grafo, hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		vértices = grafo.añada_raíces(hash_de_raíces)
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

	def ej4cg(grafo, step,número_de_raíces)
		max = 100
		rs = {:raíz => número_de_raíces.times.collect { rand(max-step..max) }}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor-step...padre.valor)]} }
		método4congrafo(grafo, rs,ld,lt)
	end

	def métodoSympiknosi(grafo, hash_de_raíces, lambda_de_desarollo)
		if grafo.nil?
			grafo = Grafo.new
		end
		vértices = grafo.añada_raíces(hash_de_raíces)
		while ! vértices.nil?
			min = vértices.min { |a, b| a.valor <=> b.valor }.valor
			max = vértices.max { |a, b| a.valor <=> b.valor }.valor
			groups = vértices.group_by { |vértice| vértice.valor == min || vértice.valor == max }
			padres = groups[true]
			vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres))
			vértices = groups[false]
			if ! vértices.nil?
				vértices.concat(vértices_nuevos)
			end
		end
		grafo
	end

	def ejSimp1(grafo, número_de_raíces, max)
		rs = {:raíz => número_de_raíces.times.collect { rand(max) }}
		ld = lambda { |(min, max)| { :m => [(min.valor+max.valor)/2] } }
		métodoSympiknosi(grafo, rs,ld)
	end

	def métodoSympiknosi2(grafo, hash_de_raíces, lambda_de_desarollo)
		if grafo.nil?
			grafo = Grafo.new
		end
		vértices = grafo.añada_raíces(hash_de_raíces)
		while vértices.count > 1
			padres = 2.times.collect { vértices.delete_at( rand(vértices.count) ) }
			vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres))
			vértices.concat(vértices_nuevos)
		end
		grafo
	end

	def ejSimp2(grafo, número_de_raíces, max)
		rs = {:raíz => número_de_raíces.times.collect { rand(max) }}
		ld = lambda { |(min, max)| { :m => [(min.valor+max.valor)/2] } }
		métodoSympiknosi2(grafo, rs,ld)
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