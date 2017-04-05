
require 'fileutils'

module Exportable

	def export_dot(filename, dotador)
		File.write("#{filename}.dot" ,dotador.grafo_to_dot(self))
	end

	def export_png(filename, dotador, layouts)
		export_dot(filename, dotador)
		if layouts == :all
			layouts = [:dot, :fdp, :neato, :sfdp, :twopi]
		elsif layouts.is_a?(Symbol)
			layouts = [layouts]
		elsif ! layouts.is_a? Array
			puts "Exception"
		end

		layouts.map(&:to_s).each do |layout|
			%x(#{layout} -Tpng #{filename}.dot -o #{filename}_#{layout}.png)
		end
	end

	# Ίσως δεν δουλεύουν οι παρακάτω.


	def export_png_slow_motion(filename, dotador, layout, directory)
		#FileUtils.rm_rf(directory)
		#Dir.mkdir(directory)

		dot = "digraph grafo {\n  #{decorador.preámbulo}\n" #rankdir=LR\n

		dot = @furñés.each_with_índice.inject(dot) do |acc, (furñá,índice)|
			acc += furñá.to_dot(decorador) + "\n"

			dot_file_name = "#{directory}/#{filename}_#{índice}.dot"
			png_file_name = "#{directory}/#{filename}_#{índice}_#{layout}.png"
			File.write(dot_file_name,acc+"}")
			%x(#{layout.to_s} -Tpng #{dot_file_name} -o #{png_file_name})
			
			acc
		end

		File.write("spawn.dot",dot+"}")
		%x(#{layout} -Tpng spawn.dot -o spawn_#{layout}.png)
	end

	def export_dot_string(string,índice,decorador)
		File.write("spawn_#{índice}.dot",string)
	end

 	
end


class ExportadorDirecto

	attr_reader :log

	def initialize(grafo, dotador, layouts)
		@grafo = grafo
		@grafo.add_observer(self)
		@dotador = dotador
		@layouts = layouts
		@filename = "e"
		@log = ""
		@índice = 0
		@dirname = Time.now.to_i.to_s
		Dir.mkdir("exports/#{@dirname}")
		layouts.each do |layout|
			Dir.mkdir("exports/#{@dirname}/#{layout}")
		end
	end

	def índice
		@índice += 1
	end

	def update(symbol, object)
		@log += "+"
		case symbol
		when :furñá
			@log += "f"
			@layouts.each do |layout|
				@grafo.export_png("#{@dirname}/#{layout}/#{@filename}_#{índice}_#{layout}", @dotador, layout)
			end
		when :vértice
			@log += "v"
		else
			@log += "error"
		end
	end
end