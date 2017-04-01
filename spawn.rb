
=begin
	
Πώς δημιουργείται ένας κόμβος;
Βασική κατηγορία είναι αυτής της φουρνιάς. Κατά τη διάρκεια μιας φουρνιάς
ένα σύνολο κόμβων P γεννούν κάποιους άλλους κόμβους H για κάποια αιτία R
και ίσως κάποιους άλλους κόμβους H' για κάποια αιτία R' και ούτω καθεξής.

Επομένως ένας κόμβος έχει:
- padres
- razón
- hermanos: αδέρφια που γεννήθηκαν στην ίδια φουρνιά λόγω της ίδιας αιτίας
- hermotros: αδέρφια που γεννήθηκαν στην ίδια φουρνιά λόγω διαφορετικής αιτίας


Τι πρέπει να συμβεί όταν δημιουργείται ένας κόμβος;
- Φτιάχνεται το αντικείμενο Nodo.
- Χρειαζόμαστε τους γονείς, το ραθόν και το valor
- Μπαίνει στη λίστα των παιδιών κάθε πατέρα του.
- Μπαίνει στη λίστα με τους κόμβους όλου του δέντρου
- Ανανεώνεται το dot.

=end

class Dot

	def initialize(pirhini, name = "γράφος")
		@dot = "digraph #{name} {\nrankdir=LR\n"

	end

	def to_s
		@dot + "}"
	end

	def añada_línea(texto)
		@dot += texto + "\n"
	end
end

# PRV -> PRH -> PRHi -> PiRHi -> Dot

class Furñá

	def initialize(padres, hash)
		@padres = padres
		@hash = hash
	end

	def to_dot(decorador)
		dot = ""

		dot_padres = @padres.inject("") do |acc, padre|
			acc + "#{padre.index} "
		end

		@hash.each do |razón, hijos|
			dot_razón = "[#{decorador.decar(razón)}]"

			dot_hijos = hijos.inject("") do |acc, hijo|
				acc + "#{hijo.index}[#{decorador.decan(hijo)}]"
			end

			dot += "{ #{dot_padres} } -> { #{dot_hijos} }#{dot_razón}\n"
		end
		dot
	end
end

class Decorador

	def initialize(lambda_de_nodo, lambda_de_razón)
		@lambda_de_nodo = lambda_de_nodo
		@lambda_de_razón = lambda_de_razón
	end

	def decan(nodo)
		@lambda_de_nodo.call(nodo)
	end

	def decar(razón)
		@lambda_de_razón.call(razón)
	end
end

class LambdasDeNodo
	
	def self.lleno
		lambda { |nodo| }
	end

	def self.valor
		lambda { |nodo| "label=#{nodo.valor}" }
	end

end

class LambdasDeRazón
	
	def self.lleno
		lambda { |razón| }
	end
	
	def self.razón
		lambda { |razón| "label=#{razón}" }
	end

end

class Decoradores

	def self.valor_razón
		Decorador.new( 
			LambdasDeNodo.valor,
			LambdasDeRazón.razón
		)
	end

	def self.valor
		Decorador.new( 
			LambdasDeNodo.valor,
			LambdasDeRazón.lleno
		)
	end

	def self.razón
		Decorador.new( 
			LambdasDeNodo.lleno,
			LambdasDeRazón.razón
		)
	end

	def self.lleno
		Decorador.new( 
			LambdasDeNodo.lleno,
			LambdasDeRazón.lleno
		)
	end
end

class ConstructoresDeRed

	def self.método1(hash_de_raíces, lambda_de_desarollo, lambda_de_terminal)
		red = Red.new
		nodos =[]
		hash_de_raíces.each_pair do |razón, valor|
			nodos = red.añada_raíces(hash_de_raíces)
		end
		while ! nodos.empty?
			padre = nodos.pop
			if ! lambda_de_terminal.call(padre)
				nodos_nuevos = red.cree_furñá([padre], lambda_de_desarollo.call(padre))
				nodos.concat(nodos_nuevos)
			end
		end
		red
	end

	def self.ex1
		rs = {:raíz => [10,20]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método1(rs,ld,lt)
	end

	def self.ex1b(valor_de_raíz, hijos)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(hijos)).times.collect { rand(padre.valor) } } }
		self.método1(rs,ld,lt)
	end

	def self.método2(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		red = Red.new
		nodos = red.añada_raíces(hash_de_raíces)
		while ! nodos.empty?
			particiones = nodos.group_by { |nodo| nodo.valor }
			nodos = []
			particiones.each_value do |padres|
				if ! lambda_terminal.call(padres[0])						
					nodos_nuevos = red.cree_furñá(padres, lambda_de_desarollo.call(padres[0]))
					nodos.concat(nodos_nuevos)
				end
			end
		end
		red
	end

	def self.ex2
		rs = {:raíz => [10,11,12,13]}
		lt = lambda { |nodo| nodo.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método2(rs,ld,lt)
	end

	def self.método3(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		red = Red.new
		nodos = red.añada_raíces(hash_de_raíces)
		while ! nodos.empty?
			particiones = nodos.group_by { |nodo| nodo.valor }
			padres = particiones.max[1]
			padres.each { |p| nodos.delete(p) }
			if ! lambda_terminal.call(padres[0])						
				nodos_nuevos = red.cree_furñá(padres, lambda_de_desarollo.call(padres[0]))
				nodos.concat(nodos_nuevos)
			end
		end
		red
	end

	def self.ex3
		rs = {:raíz => (13..21).to_a}
		lt = lambda { |nodo| nodo.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método3(rs,ld,lt)
	end

end

class Red

	attr_reader :nodos, :furñés

	def initialize
		@nodos = []
		@furñés = []
	end

	def añada_raíces(hash)
		cree_furñá([], hash)
	end

	def cree_furñá(padres, hash_con_razónes_y_valores_de_hijos)
		todos_los_hijos = []
		hash_con_razónes_y_hijos = {}

		hash_con_razónes_y_valores_de_hijos.each do |razón, valores|
			hijos = []
			valores.each do |valor|
				índice_de_nodo = @nodos.size
				nodo = Nodo.new(padres, razón, valor, índice_de_nodo)
				@nodos << nodo
				hijos << nodo
				todos_los_hijos << nodo
			end
			hash_con_razónes_y_hijos[razón] = hijos
		end

		@furñés << Furñá.new(padres, hash_con_razónes_y_hijos)
		todos_los_hijos
	end

	def to_dot(decorador)
		dot = "digraph γράφος {\n" #rankdir=LR\n

		dot = @furñés.inject(dot) do |acc, furñá|
			acc + furñá.to_dot(decorador) + "\n"
		end

		dot + "}"
	end

	def export_dot(decorador)
		File.write('spawn.dot',to_dot(decorador))
	end

	def export_png(decorador,layout)
		export_dot(decorador)
		%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
	end

	def export_png_all(decorador)
		export_dot(decorador)
		["dot","fdp","neato","sfdp","twopi"].each do |layout|
			%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
		end
	end	

end

class Nodo

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

	def es_raíz?
		@padres.empty?
	end

	def tiene_hijos?
		hijos.empty?
	end

	def añada_hijo(nodo)
		@hijos << nodo
	end

end

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

	def spawn_


	end

end