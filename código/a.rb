def load_código
	Dir["código/*.rb"].each do |file|
		load(file)
	end
end