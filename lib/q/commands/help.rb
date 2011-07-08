module Q
	class Help
		def execute(shortcut, terms)
			shortcut = terms.shift.to_sym || :help
			commands[shortcut].help(shortcut, terms)
		end
		
		def help(shortcut, terms)
			DATA.read
		end
	end
	
	register_command(:help, Help.new)
end