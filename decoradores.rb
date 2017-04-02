
require_relative 'constructores'
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

	def initialize(preámbulo, lambda_de_vértice, lambda_de_razón)
		@preámbulo = preámbulo
		@lambda_de_vértice = lambda_de_vértice
		@lambda_de_razón = lambda_de_razón
	end

	def decan(vértice)
		@lambda_de_vértice.(vértice)
	end

	def decar(razón)
		@lambda_de_razón.(razón)
	end

end


class Lambdas

	def self.compose(*ls)
		lambda do |x|
			ls.inject("") do |acc, l|
				acc + l.(x) + " "
			end
		end
	end

end


class LambdasDeVértice < Lambdas
	
	def self.lleno
		lambda { |vértice| }
	end

	def self.valor
		lambda { |vértice| "label=#{vértice.valor}" }
	end

	def self.colorize_with_scheme(lambda_valor_to_scale)
		lambda { |vértice| "fillcolor=#{lambda_valor_to_scale.(vértice.valor)}" }
	end

	def self.la_val_to_scale(range_valores,range_colorscheme)
		step = range_valores.count.fdiv(range_colorscheme.count)
		lambda { |valor| valor.fdiv(step).ceil }
	end

	def self.v_número_de_hijos
		lambda { |vértice| "label=#{vértice.valor} fillcolor=#{vértice.cuantos_hijos_tiene+1}" }
	end

	def self.número_de_hijos
		lambda { |vértice| "label=#{vértice.cuantos_hijos_tiene} fillcolor=#{vértice.cuantos_hijos_tiene+1}" }
	end

	def self.v__número_de_hijos
		lambda { |vértice| "label=#{vértice.valor}#{vértice.cuantos_hijos_tiene} fillcolor=#{vértice.cuantos_hijos_tiene+1}" }
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
			Preámbulos.lleno,
			LambdasDeVértice.valor,
			LambdasDeRazón.razón
		)
	end

	def self.valor
		Decorador.new( 
			Preámbulos.lleno,
			LambdasDeVértice.valor,
			LambdasDeRazón.lleno
		)
	end

	def self.razón
		Decorador.new( 
			Preámbulos.lleno,
			LambdasDeVértice.lleno,
			LambdasDeRazón.razón
		)
	end

	def self.lleno
		Decorador.new( 
			Preámbulos.lleno,
			LambdasDeVértice.lleno,
			LambdasDeRazón.lleno
		)
	end

	def self.valor_color(color_scheme)
		Decorador.new( 
			Preámbulos.v_filled_color_scheme(color_scheme),
			LambdasDeVértice.valor_número_de_hijos,
			LambdasDeRazón.lleno
		)
	end

	def self.color(color_scheme)
		Decorador.new( 
			Preámbulos.v_filled_color_scheme(color_scheme),
			LambdasDeVértice.número_de_hijos,
			LambdasDeRazón.lleno
		)
	end

	def self.color2(color_scheme)
		Decorador.new( 
			Preámbulos.v_filled_color_scheme(color_scheme),
			LambdasDeVértice.v__número_de_hijos,
			LambdasDeRazón.lleno
		)
	end	

	def self.color_si_tiene_hijos
		Decorador.new( 
			Preámbulos.v_filled,
			LambdasDeVértice.v_color_si_tiene_hijos("crimson", "cornsilk"),
			LambdasDeRazón.lleno
		)
	end	

end