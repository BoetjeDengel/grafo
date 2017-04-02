
require_relative 'decoradores'
require_relative 'grafo'

class Dotador

	attr_reader :decorador

	def initialize(decorador)
		@decorador = decorador
	end

	def grafo_to_dot(grafo, nombre = "grafo")
		dot = preámbulo_to_dot(nombre)

		dot = grafo.each_furñá.inject(dot) do |acc, furñá|
			acc + furñá_to_dot(furñá) + "\n"
		end

		dot + "}"
	end

	def preámbulo_to_dot(nombre = "grafo")
		dot = "digraph #{nombre} {\n  #{@decorador.preámbulo}\n" #rankdir=LR\n
	end

	def furñá_to_dot(furñá)
		ptd = padres_to_dot(furñá.padres)	# Το βάζω εδώ από την αρχή γιατί είναι αναλλοίωτο.

		furñá.hash.inject("  ") do |acc, (razón, hijos)|
			acc + "{ #{ptd}} -> { #{hijos_to_dot(hijos)}} [#{razón_to_dot(razón)}]\n"
		end
	end

	def padre_to_dot(padre)
		padre.índice
	end

	def padres_to_dot(padres)
		padres.inject("") do |acc, padre|
			acc + "#{padre_to_dot(padre)} "
		end
	end

	def hijo_to_dot(hijo)
		"#{hijo.índice}[#{@decorador.decav(hijo)}]"
	end

	def hijos_to_dot(hijos)
		hijos.inject("") do |acc, hijo|
			acc + hijo_to_dot(hijo) + " "
		end
	end

	def razón_to_dot(razón)
		@decorador.decar(razón)
	end

end