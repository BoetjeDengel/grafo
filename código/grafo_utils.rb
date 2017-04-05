module GrafoUtils

	def max_number_of_children
		each_vértice.max_by do |vértice|
			vértice.número_de_hijos
		end .número_de_hijos
	end

	def min_number_of_children
		each_vértice.min_by do |vértice|
			vértice.número_de_hijos
		end .número_de_hijos
	end

	def range_number_of_children
		(min_number_of_children..max_number_of_children)
	end

	def array_of_numbers_of_children
		each_vértice.collect do |vértice|
			vértice.número_de_hijos
		end 
	end

	def array_of_unique_numbers_of_children
		array_of_numbers_of_children.uniq.sort
	end

end