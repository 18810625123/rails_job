root = __FILE__.split('/config')[0]
path = "#{root}/app/models/jobs"
Dir.foreach path do |f|
	if(f[0] != '.')
		file = "#{path}/#{f}"
		require file
		puts "require #{file}"
		
	end
end
