
require_relative 'grafo'

module Constructores

	class Ejemplo
	
		attr_reader :method, :description

		def initialize(method, description)
			@method = method
			@description = description
		end
	end

###############################################################################

	def ejemplos
		[] << Ejemplo.new(
			:ej_cadena,
			"Δημιουργεί μια αλυσίδα από το 17 μέχρι το 0 (με 18 κόμβους)."
		) << Ejemplo.new(
			:ej_cadenas,
			"Δημιουργεί τέσσερις παράλληλες αλυσίδες από το 12, 7, 29 και 16 αντίστοιχα μέχρι το 0."
		) << Ejemplo.new(
			:ej_cadenas_same_length,
			"Δημιουργεί τέσσερις παράλληλες αλυσίδες από το 12, 24, 36 και 48 αντίστοιχα μέχρι το 0 με 13 κόμβους η καθεμία."
		) << Ejemplo.new(
			:ej_cadena_no_valor,
			"Δημιουργεί μια αλυσίδα δώδεκα κόμβων με τιμή 0 και αιτία :m."
		) << Ejemplo.new(
			:ej_cadena_no_valor_different_edge,
			"Δημιουργεί μια αλυσίδα δώδεκα κόμβων με τιμή 0 και αιτία ίση με την απόσταση από τη ρίζα."
		) << Ejemplo.new(
			:ej_binary_minus_one_minus_two_one_reason,
			"Δημιουργεί δυαδικό δέντρο με ρίζα το 6 και αναδρομικά το αριστερό παιδί είναι κατά ένα μικρότερο ενώ το δεξί κατά δύο. Σταματάει στο 0. Μία αιτία."
		) << Ejemplo.new(
			:ej_binary_minus_one_minus_two_two_reasons,
			"Δημιουργεί δυαδικό δέντρο με ρίζα το 6 και αναδρομικά το αριστερό παιδί είναι κατά ένα μικρότερο ενώ το δεξί κατά δύο. Σταματάει στο 0. Δύο αιτίες."
		) << Ejemplo.new(
			:ej_closing_tree,
			"Δημιουργεί δέντρο όπου κάθε κόμβος έχει όσα παιδιά και η τιμή του. Ρίζα είναι το 6."
		)
	end
#______________________________________________________________________________

	def rejemplos
		[] << Ejemplo.new(
			:rej_closing_tree,
			"Δημιουργεί δέντρο όπου κάθε κόμβος έχει (1+rand(valor)) παιδιά, το καθένα με rand(valor) τιμή. Ρίζα είναι το 10."
		) << Ejemplo.new(
			:rej_sympiknosi_minmax_group_selection,
			"Δημιουργεί δέντρο minmax group συμπύκνωσης 25 ρίζων με τιμή rand(100)."
		) << Ejemplo.new(
			:rej_sympiknosi_random_2_selection,
			"Δημιουργεί δέντρο συμπύκνωσης 25 ρίζων με τιμή rand(100) με τυχαία επιλογή δύο κόμβων."
		) << Ejemplo.new(
			:rej_sympiknosi_random_5_selection,
			"Δημιουργεί δέντρο συμπύκνωσης 50 ρίζων με τιμή rand(1000) με τυχαία επιλογή πέντε κόμβων."
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
		cadena(Grafo.new, vr, ld, lt)
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
		cadena_no_valor(Grafo.new, 11)
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
		cadena_no_valor_different_edge(Grafo.new, 11)
	end

###############################################################################

# Αυτή είναι μια μέθοδος που χρησιμοποιήθηκε η έννοια της γεννιάς.
# Κάθε φορά που καλείται η συνθήκη του while έχουμε μια νέα γενιά.
# Θα μπορούσε ίσως να είχε προγραμματιστεί πιο φλατ.
	def one_father(grafo, hash_de_raíces, lambda_de_desarollo, lambda_terminal)
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

	def ej_binary_minus_one_minus_two_one_reason
		hs = {:raíz => [6]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [padre.valor-1, padre.valor-2] } }
		one_father(Grafo.new, hs, ld, lt)
	end

	def ej_binary_minus_one_minus_two_two_reasons
		hs = {:raíz => [6]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:l => [padre.valor-1], :r => [padre.valor-2] } }
		one_father(Grafo.new, hs, ld, lt)
	end

	def ej_closing_tree
		hs = {:raíz => [5]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| p = padre.valor; {:m => [p-1]*p } }
		one_father(Grafo.new, hs, ld, lt)
	end

#______________________________________________________________________________

	def rej_closing_tree
		hs = {:raíz => [8]}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(padre.valor)).times.collect { rand(padre.valor) } } }
		one_father(Grafo.new, hs, ld, lt)
	end

###############################################################################

	def sympiknosi_minmax_group_selection(grafo, hash_de_raíces, lambda_de_desarollo)
		vértices = grafo.añada_raíces(hash_de_raíces)
		while ! vértices.nil?
			min, max = vértices.minmax { |a, b| a.valor <=> b.valor }.map(&:valor)
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

	def rej_sympiknosi_minmax_group_selection
		número_de_raíces = 25
		max = 100
		rs = {:raíz => número_de_raíces.times.collect { rand(max) }}
		ld = lambda { |selected| { :m => [selected.map(&:valor).sum / selected.count] }	}
		sympiknosi_minmax_group_selection(Grafo.new, rs, ld)
	end
#______________________________________________________________________________

	def sympiknosi_random_selection(grafo, number_of_selected_nodes, hash_de_raíces, lambda_de_desarollo)
		vértices = grafo.añada_raíces(hash_de_raíces)
		while vértices.count > 1
			number = [ number_of_selected_nodes, vértices.count ].min
			padres = number.times.collect { vértices.delete_at( rand(vértices.count) ) }
			vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.(padres))
			vértices.concat(vértices_nuevos)
		end
		grafo
	end

	def rej_sympiknosi_random_2_selection
		número_de_raíces = 25
		max = 100
		rs = {:raíz => número_de_raíces.times.collect { rand(max) }}
		ld = lambda { |(min, max)| { :m => [(min.valor+max.valor)/2] } }
		sympiknosi_random_selection(Grafo.new, 2, rs, ld)
	end

	def rej_sympiknosi_random_5_selection
		número_de_raíces = 50
		max = 1000
		rs = {:raíz => número_de_raíces.times.collect { rand(max) }}
		ld = lambda { |selected| { :m => [selected.map(&:valor).sum / selected.count] }	}
		sympiknosi_random_selection(Grafo.new, 5, rs, ld)
	end

end

=begin
###############################################################################

	def height_at_most(max_height)
		while ! padre.nil? && padre.height < max_height
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

=end