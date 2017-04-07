
require_relative 'grafo'

class Utils
	def split_points(enum_length, parts)
		q, r = enum_length.divmod(parts)
		puts q
		puts r
		split_points = []
		split_points = (1..r).collect { |i| i * (q + 1) }
		#split_points.concat((1..r).collect { |i| i * (q + 1) })
		split_points
	end
end


class Decorador

	attr_reader :preámbulo

	def initialize(preámbulo: Lambdas.lleno, vértice: Lambdas.lleno, razón: Lambdas.lleno)
		@l_preámbulo = preámbulo
		@l_vértice = vértice
		@l_razón = razón
	end

	def decop(grafo)
		@l_preámbulo.(grafo)
	end

	def decov(vértice)
		@l_vértice.(vértice)
	end

	def decor(razón)
		@l_razón.(razón)
	end

end


class Lambdas

	def self.lleno
		lambda { |x| }
	end

	def self.compose(*ls)
		lambda do |x|
			ls.inject("") do |acc, l|
				acc + l.(x) + " "
			end
		end
	end

#	def self.sintheto(attributes)
	def self.sintheto(strings)
		lambda { |vértice| strings.join(' ')}
	end


end


class LambdasDeVértice < Lambdas
	def self.valor
		lambda { |vértice| "label=#{vértice.valor}" }
	end
end

module DotAttributes

	def opt(attr, string)
		"#{attr}=#{string}"
	end

	def optl(attr, lambda, x)
		"#{attr}=\#\{lambda.(x)\}"
	end

	def optl2(attribute, block); "#{attribute}=lambda { |x| #{block} }"; end


	def fillcolor(x)
		"fillcolor=#{yield x}"
	end

	def label(lambda)
		"label=#{lambda.(x)}"
	end

end

class K

	def self.la_val_to_scale(range_valores,range_colorscheme)
		step = range_valores.count.fdiv(range_colorscheme.count)
		lambda { |valor| valor.fdiv(step).ceil }
	end

	def self.v_número_de_hijos
		sintheto([	"label=#{vértice.valor}",
					"fillcolor=#{vértice.número_de_hijos+1}" 
				])		
	end

	def self.número_de_hijos
		sintheto([	"label=#{vértice.número_de_hijos}",
					"fillcolor=#{vértice.número_de_hijos+1}" 
				])
	end

	def self.v__número_de_hijos
		sintheto([	"label=#{vértice.valor}#{vértice.número_de_hijos}",
					"fillcolor=#{vértice.número_de_hijos+1}" 
				])
	end	

	def self.v_color_si_tiene_hijos(color_true, color_false)
		lambda { |vértice| "label=#{vértice.valor} fillcolor=#{vértice.tiene_hijos ? color_true : color_false}" }
	end	


end



class LambdasDeRazón < Lambdas
	
	def self.lleno
		lambda { |razón| }
	end
	
	def self.razón
		lambda { |razón| "label=#{razón}" }
	end

end


class Preámbulos

	def self.lleno
		""
	end

	def self.vértice(string)
		"node [#{string}]"
	end

	def self.v_filled
		self.vértice("style=filled")
	end

	def self.v_filled_color_scheme(color_scheme)
		self.vértice("style=filled colorscheme=#{color_scheme}")
	end
end


class Decoradores

	def self.valor_razón
		Decorador.new(
			:vértice => LambdasDeVértice.valor,
			:razón => LambdasDeRazón.razón
		)
	end

	def self.valor
		Decorador.new( 
			:vértice => LambdasDeVértice.valor
		)
	end

	def self.razón
		Decorador.new( 
			:razón => LambdasDeRazón.razón
		)
	end

	def self.valor_color
		Decorador.new( 
			:preámbulo => lambda { |grafo| "node [style=filled]" },
			:vértice => lambda { |vértice| "label=#{vértice.valor} fillcolor=firebrick" }
		)
	end

	def self.color(color_scheme_sort)
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled colorscheme=#{color_scheme_sort}#{[3,grafo.max_number_of_children+1].max}]" },
			:vértice => lambda { |vértice| "label=#{vértice.valor} fillcolor=#{vértice.número_de_hijos+1}" }
		)
	end


	def self.no_valor_color(color_scheme_sort = :spectral)
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled colorscheme=#{color_scheme_sort}#{[3,grafo.max_number_of_children+1].max}]" },
			:vértice => lambda { |vértice| "label=\"\" fillcolor=#{vértice.número_de_hijos+1}" }
		)
	end


	def self.n_de_hijos_color(color_scheme_sort = :spectral)
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled colorscheme=#{color_scheme_sort}#{[3,grafo.max_number_of_children+1].max}]" },
			:vértice => lambda { |vértice| "label=#{vértice.número_de_hijos} fillcolor=#{vértice.número_de_hijos+1}" }
		)
	end


	def self.color_y_hijos(color_scheme_sort)
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled colorscheme=#{color_scheme_sort}#{[3,grafo.max_number_of_children+1].max}]" },
			:vértice => lambda { |vértice| "label=#{vértice.valor}#{vértice.número_de_hijos} fillcolor=#{vértice.número_de_hijos+1}" }
		)
	end


	def self.color2(color_scheme)
		Decorador.new( 
#			Preámbulos.v_filled_color_scheme(color_scheme),
#			LambdasDeVértice.v__número_de_hijos,
		)
	end	

	def self.color_si_tiene_hijos
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled]" },
			:vértice => lambda { |vértice| "label=#{vértice.valor} fillcolor=#{ vértice.tiene_hijos ? "orangered" : "cornsilk" }" }
		)
	end


	def self.no_valor_color_si_tiene_hijos
	#preprocess
		Decorador.new(
			:preámbulo => lambda { |grafo| "node [style=filled]" },
			:vértice => lambda { |vértice| "label=\"\" fillcolor=#{ vértice.tiene_hijos ? "orangered" : "cornsilk" }" }
		)
	end

end