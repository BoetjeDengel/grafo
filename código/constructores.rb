
require_relative 'grafo'

module ConstructoresDeGrafo

	class Ejemplo
	
		attr_reader :method, :description

		def initialize(method, description)
			@method = method
			@description = description
		end
	end

###############################################################################

	def ejemplos
		ejemplos = []
		ejemplos << Ejemplo.new(
			:ej_cadena,
			"Δημιουργεί μια αλυσίδα από το 17 μέχρι το 0 (με 18 κόμβους)."
		)
		ejemplos << Ejemplo.new(
			:ej_cadenas,
			"Δημιουργεί τέσσερις παράλληλες αλυσίδες από το 12, 7, 29 και 16 αντίστοιχα μέχρι το 0."
		)
		ejemplos << Ejemplo.new(
			:ej_cadenas_same_length,
			"Δημιουργεί τέσσερις παράλληλες αλυσίδες από το 12, 24, 36 και 48 αντίστοιχα μέχρι το 0 με 13 κόμβους η καθεμία."
		)
		ejemplos << Ejemplo.new(
			:ej_cadena_no_valor,
			"Δημιουργεί μια αλυσίδα δώδεκα κόμβων με τιμή 0 και αιτία :m."
		)
		ejemplos << Ejemplo.new(
			:ej_cadena_no_valor_different_edge,
			"Δημιουργεί μια αλυσίδα δώδεκα κόμβων με τιμή 0 και αιτία ίση με την απόσταση από τη ρίζα."
		)
	end

###############################################################################

	def cadena(grafo, valor_de_raíz, lambda_de_desarollo, lambda_terminal)
		padre = grafo.añada_raíces({:raíz => [valor_de_raíz]})[0]
		while ! lambda_terminal.(padre)			
			padre = grafo.cree_furñá([padre], lambda_de_desarollo.(padre))[0]
		end
		grafo
	end

	def ej_cadena
		vr = 17
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1]} }
		cadena(grafo = Grafo.new, vr, ld, lt)
	end

	def ej_cadenas
		grafo = Grafo.new
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1]} }
		cadena(grafo, 12, ld, lt)
		cadena(grafo, 7, ld, lt)
		cadena(grafo, 29, ld, lt)
		cadena(grafo, 16, ld, lt)
	end

	def ej_cadenas_same_length
		grafo = Grafo.new
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1]} }
		cadena(grafo, 12, ld, lt)
		ld = lambda { |padre| {:m => [padre.valor-2]} }
		cadena(grafo, 24, ld, lt)
		ld = lambda { |padre| {:m => [padre.valor-3]} }
		cadena(grafo, 36, ld, lt)
		ld = lambda { |padre| {:m => [padre.valor-4]} }
		cadena(grafo, 48, ld, lt)
	end	
#______________________________________________________________________________

	def cadena_no_valor(grafo, length)
		same_valor = 0
		padre_ary = []
		(length+1).times do
			padre_ary = grafo.cree_furñá(padre_ary, {:m => [same_valor]})
		end
		grafo
	end

	def ej_cadena_no_valor
		cadena_no_valor(grafo = Grafo.new, 11)
	end
#______________________________________________________________________________

	def cadena_no_valor_different_edge(grafo, length)
		same_valor = 0
		padre_ary = []
		(0..length).each do |index|
			padre_ary = grafo.cree_furñá(padre_ary, {index => [same_valor]})
		end
		grafo
	end	

	def ej_cadena_no_valor_different_edge
		cadena_no_valor_different_edge(grafo = Grafo.new, 11)
	end

end
=begin
###############################################################################

	def binary_value(grafo, valor_de_raíz, lambda_de_desarollo, lambda_terminal)
		to_be_developed = grafo.añada_raíces({:raíz => [valor_de_raíz]})
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

# Αυτή είναι μια μέθοδος που χρησιμοποιήθηκε η έννοια της γεννιάς.
# Κάθε φορά που καλείται η συνθήκη του while έχουμε μια νέα γενιά.
# Θα μπορούσε ίσως να είχε προγραμματιστεί πιο φλατ.
#______________________________________________________________________________

	def ej_binary_minus_one_minus_two_one_reason
		vr = 6
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1, padre.valor-2] } }
		binary_value(grafo = Grafo.new, vr, ld, lt)
	end

	ejemplos << Ejemplo.new(
		:ej_binary_minus_one_minus_two_one_reason,
		"Δημιουργεί δυαδικό δέντρο με ρίζα το 6 και αναδρομικά το αριστερό παιδί είναι κατά ένα μικρότερο ενώ το δεξί κατά δύο. Σταματάει στο 0. Μία αιτία."
	)
#______________________________________________________________________________

	def ej_binary_minus_one_minus_two_two_reasons
		vr = 6
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:l => [padre.valor-1], :r => [padre.valor-2] } }
		binary_value(grafo = Grafo.new, vr, ld, lt)
	end

	ejemplos << Ejemplo.new(
		:ej_binary_minus_one_minus_two_two_reasons,
		"Δημιουργεί δυαδικό δέντρο με ρίζα το 6 και αναδρομικά το αριστερό παιδί είναι κατά ένα μικρότερο ενώ το δεξί κατά δύο. Σταματάει στο 0. Δύο αιτίες."
	)
#______________________________________________________________________________

	def binary_value(grafo, valor_de_raíz, lambda_de_desarollo, lambda_terminal)
		to_be_developed = grafo.añada_raíces({:raíz => [valor_de_raíz]})
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

		def self.binary_value
			grafo = Grafo.new
			tbds = grafo.añada_raíces({ :raíz => [0] })
			tbds = Array(tbds)
			padre = tbds.delete_at(0)
			while ! padre.nil? && padre.height < max_height
				vértices_nuevos = grafo.cree_furñá([padre], { :m => (1 + rand(max_children)).times.collect { 0 } } )
				tbds.concat(vértices_nuevos)
				padre = tbds.delete_at(0)
			end
			grafo
		end
	end

end

=begin
	class Ejemplo
	
		attr_reader :proc, :description

		def initialize(proc, description)
			@proc = proc
#			@hash = hash
			@description = description
		end
	end


	def self.métodoR(max_nodes, max_children)
		grafo = Grafo.new
		tbds = grafo.añada_raíces({ :raíz => [0] })
		tbds = Array(tbds)
		while ! tbds.empty? && grafo.size < max_nodes
			vértices_nuevos = grafo.cree_furñá([tbds.delete_at(0)], { :m => (1 + rand(max_children)).times.collect { 0 } } )
			tbds.concat(vértices_nuevos)
		end
		grafo
	end

	def self.métodoR2(max_height, max_children)
		grafo = Grafo.new
		tbds = grafo.añada_raíces({ :raíz => [0] })
		tbds = Array(tbds)
		padre = tbds.delete_at(0)
		while ! padre.nil? && padre.height < max_height
			vértices_nuevos = grafo.cree_furñá([padre], { :m => (1 + rand(max_children)).times.collect { 0 } } )
			tbds.concat(vértices_nuevos)
			padre = tbds.delete_at(0)
		end
		grafo
	end

	class MétodoCadena

		def self.método1(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
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
			end
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
			min, max = vértices.minmax { |a, b| a.valor <=> b.valor }.valor
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