
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
- Φτιάχνεται το αντικείμενο Vértice.
- Χρειαζόμαστε τους γονείς, το ραθόν και το valor
- Μπαίνει στη λίστα των παιδιών κάθε πατέρα του.
- Μπαίνει στη λίστα με τους κόμβους όλου του δέντρου
- Ανανεώνεται το dot.

=end

#υπάρχει τρόπος να απλοποιήσω τις μεθόδους στους Constructores;

class Furñá

	def initialize(padres, hash)
		@padres = padres
		@hash = hash
	end

	def to_dot(decorador)
		dot = "  "

		dot_padres = @padres.inject("") do |acc, padre|
			acc + "#{padre.index} "
		end

		@hash.each do |razón, hijos|
			dot_razón = "[#{decorador.decar(razón)}]"

			dot_hijos = hijos.inject("") do |acc, hijo|
				acc + "#{hijo.index}[#{decorador.decan(hijo)}] "
			end

			dot += "{ #{dot_padres}} -> { #{dot_hijos}} #{dot_razón}\n"
		end
		dot
	end
end


class Grafo

	def initialize
		@vértices = []
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
				índice_de_vértice = @vértices.size
				vértice = Vértice.new(padres, razón, valor, índice_de_vértice)
				@vértices << vértice
				hijos << vértice
				todos_los_hijos << vértice
			end
			hash_con_razónes_y_hijos[razón] = hijos
		end

		@furñés << Furñá.new(padres, hash_con_razónes_y_hijos)
		todos_los_hijos
	end

	def to_dot(decorador, nombre = "grafo")
		dot = "digraph #{nombre} {\n" #rankdir=LR\n

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

	def es_raíz?
		@padres.empty?
	end

	def tiene_hijos?
		hijos.empty?
	end

	def añada_hijo(vértice)
		@hijos << vértice
	end

end


class Decorador

	def initialize(lambda_de_vértice, lambda_de_razón)
		@lambda_de_vértice = lambda_de_vértice
		@lambda_de_razón = lambda_de_razón
	end

	def decan(vértice)
		@lambda_de_vértice.call(vértice)
	end

	def decar(razón)
		@lambda_de_razón.call(razón)
	end
end


class LambdasDeVértice
	
	def self.lleno
		lambda { |vértice| }
	end

	def self.valor
		lambda { |vértice| "label=#{vértice.valor}" }
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
			LambdasDeVértice.valor,
			LambdasDeRazón.razón
		)
	end

	def self.valor
		Decorador.new( 
			LambdasDeVértice.valor,
			LambdasDeRazón.lleno
		)
	end

	def self.razón
		Decorador.new( 
			LambdasDeVértice.lleno,
			LambdasDeRazón.razón
		)
	end

	def self.lleno
		Decorador.new( 
			LambdasDeVértice.lleno,
			LambdasDeRazón.lleno
		)
	end
end


class ConstructoresDeGrafo

	def self.método1(hash_de_raíces, lambda_de_desarollo, lambda_de_terminal)
		grafo = Grafo.new
		vértices = grafo.añada_raíces(hash_de_raíces)
		while ! vértices.empty?
			padre = vértices.pop
			if ! lambda_de_terminal.call(padre)
				vértices_nuevos = grafo.cree_furñá([padre], lambda_de_desarollo.call(padre))
				vértices.concat(vértices_nuevos)
			end
		end
		grafo
	end

	def self.ej1
		rs = {:raíz => [10,20]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método1(rs,ld,lt)
	end

	def self.ej1b(valor_de_raíz, hijos)
		rs = {:raíz => [valor_de_raíz]}
		lt = lambda { |n| n.valor <= 0 }
		ld = lambda { |padre| {:m => (1+rand(hijos)).times.collect { rand(padre.valor) } } }
		self.método1(rs,ld,lt)
	end

	def self.método2(hash_de_raíces, lambda_de_desarollo, lambda_terminal)
		grafo = Grafo.new
		vértices = grafo.añada_raíces(hash_de_raíces)
		while ! vértices.empty?
			particiones = vértices.group_by { |vértice| vértice.valor }
			vértices = []
			particiones.each_value do |padres|
				if ! lambda_terminal.call(padres[0])						
					vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.call(padres[0]))
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
		while ! vértices.empty?
			particiones = vértices.group_by { |vértice| vértice.valor }
			padres = particiones.max[1]
			padres.each { |p| vértices.delete(p) }
			if ! lambda_terminal.call(padres[0])						
				vértices_nuevos = grafo.cree_furñá(padres, lambda_de_desarollo.call(padres[0]))
				vértices.concat(vértices_nuevos)
			end
		end
		grafo
	end

	def self.ej3
		rs = {:raíz => (10..21).to_a}
		lt = lambda { |vértice| vértice.valor <= 0 }
		ld = lambda { |padre| {:m => [rand(padre.valor)]} }
		self.método3(rs,ld,lt)
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