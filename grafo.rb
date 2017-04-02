
require 'observer'

require_relative 'exportable'

class Furñá

	attr_reader :padres, :hash
	def initialize(padres, hash)
		@padres = padres
		@hash = hash
	end

	def each_padre
	end

	def each_razón_hijos
	end
end


class Vértice

	attr_reader :valor, :índice

	def initialize(padres, razón, valor, índice)
		@padres = padres
		padres.each do |padre|
			padre.añada_hijo(self)
		end
		@razón = razón
		@valor = valor
		@índice = índice
#		@hermanos =[]
#		@hermotros = []
		@hijos = []
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


class Grafo
	include Enumerable, Exportable, Observable

	def initialize
		@vértices = []
		@furñés = []
	end

	def añada_vértice(vértice)
		@vértices << vértice
		changed
		notify_observers(:vértice, vértice)
	end

	def añada_furñá(furñá)
		@furñés << furñá
		changed
		notify_observers(:furñá, furñá)
	end

	def añada_raíces(hash)
		cree_furñá([], hash)
	end

=begin

Κάνουμε πράγματα παράλληλα
 - Φτιάχνουμε τα παιδιά
 - Μετατρέπουμε την προφουρνιά σε φουρνιά, 
   δηλαδή το hash με τις αιτίες και τις τιμές σε hash με τις αιτίες και κόμβους
 - Επιστρέφουμε όλα τα παιδιά ώστε να μπορούν εύκολα να αναπτυχθούν κι αυτά.
=end
	def cree_furñá(padres, hash_con_razónes_y_valores)
		todos_los_hijos = []
		hash_con_razónes_y_hijos = {}

		hash_con_razónes_y_valores.each do |razón, valores|
			hijos = []
			valores.each do |valor|
				índice = @vértices.size
				hijo = Vértice.new(padres, razón, valor, índice)
				añada_vértice(hijo)
				hijos << hijo
				todos_los_hijos << hijo
			end
			hash_con_razónes_y_hijos[razón] = hijos
		end

		añada_furñá(Furñá.new(padres, hash_con_razónes_y_hijos))

		todos_los_hijos
	end

	def each
	end

	def each_furñá(&block)

		if block_given?
			@furñés.each(&block)
		else
			@furñés.to_enum # Λάθος
		end
	end

	def each_vértice
	end

	private :añada_vértice, :añada_furñá
end