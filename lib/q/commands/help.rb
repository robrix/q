module Q
	class Help < Command
		def execute(shortcut, terms)
			shortcut = terms.shift.to_sym || :help
			Q.commands[shortcut].help(shortcut, terms)
		end
		
		def help(shortcut, terms)
			DATA.read
		end
	end
	
	register_command(:help, Help.new)
end