
require 'fileutils'
require 'observer'

require_relative 'decoradores'

class Furñá

	def initialize(padres, hash)
		@padres = padres
		@hash = hash
	end

	def to_dot(decorador)
		@hash.inject("  ") do |acc, (razón, hijos)|
			dot + "{ #{padres_to_dot}} -> { #{hijos_to_dot(hijos,decorador)}} [#{razón_to_dot}]\n"
		end
	end

	private

	def padres_to_dot
		@padres.inject("") do |acc, padre|
			acc + "#{padre.index} "
		end
	end

	def razón_to_dot(decorador)
		decorador.decar(razón)
	end

	def hijos_to_dot(hijos, decorador)
		hijos.inject("") do |acc, hijo|
			acc + "#{hijo.to_dot(decorador)} "
		end
	end

end


class Grafo
	include Observable

	def initialize
		@vértices = []
		@furñés = []
		add_observer(self)
	end

#	def añada_furñá(furñá)
#		@furñés << furñá
#
#	end

	def each_furñá(&block)

		if block_given?
			@furñés.each(&block)
		else
			@furñés.to_enum # Λάθος
		end
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
				changed
				notify_observers(:vértice, vértice)
				hijos << vértice
				todos_los_hijos << vértice
			end
			hash_con_razónes_y_hijos[razón] = hijos
		end

		furñá = Furñá.new(padres, hash_con_razónes_y_hijos)
		@furñés << furñá
		changed
		notify_observers(:furñá, furñá)
		todos_los_hijos
	end

	def to_dot(decorador, nombre = "grafo")
		dot = "digraph #{nombre} {\n  #{decorador.preámbulo}\n" #rankdir=LR\n

		dot = @furñés.inject(dot) do |acc, furñá|
			acc + furñá.to_dot(decorador) + "\n"
		end

		dot + "}"
	end

	def to_dot_slow_motion(decorador, nombre = "grafo")
		dot = "digraph #{nombre} {\n  #{decorador.preámbulo}\n" #rankdir=LR\n

		dot = @furñés.each_with_index.inject(dot) do |acc, (furñá,index)|
			export_dot_string(acc+"}",index,decorador)
			acc + furñá.to_dot(decorador) + "\n"
		end

		dot + "}"
	end


	def export_dot_string(string,index,decorador)
		File.write("spawn_#{index}.dot",string)
	end

	def export_dot(decorador)
		File.write('spawn.dot',to_dot(decorador))
	end

	def export_png(decorador,layout)
		export_dot(decorador)
		%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
	end


	def export_png_slow_motion(decorador,layout,directory)
		FileUtils.rm_rf(directory)
		Dir.mkdir(directory)

		dot = "digraph grafo {\n  #{decorador.preámbulo}\n" #rankdir=LR\n

		dot = @furñés.each_with_index.inject(dot) do |acc, (furñá,index)|
			acc += furñá.to_dot(decorador) + "\n"

			dot_file_name = "#{directory}/spawn_#{index}.dot"
			png_file_name = "#{directory}/spawn_#{index}_#{layout}.png"
			File.write(dot_file_name,acc+"}")
			%x(#{layout} -Tpng #{dot_file_name} -o #{png_file_name})
			
			acc
		end

		File.write("spawn.dot",dot+"}")
		%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
	end
 	
	def export_png_all(decorador)
		export_dot(decorador)
		["dot","fdp","neato","sfdp","twopi"].each do |layout|
			%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
		end
	end	

	def update(symbol, object)
		case symbol
		when :vértice
			puts "v"
		when :furñá
			puts "f"
		else
			puts "e"
		end
	end

end

