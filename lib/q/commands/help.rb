module Q
	class Help < Command
		def initialize
			super("COMMAND -- print help for COMMAND")
		end
		
		def execute(shortcut, terms)
			shortcut = terms.shift.to_sym unless terms.empty?
			if command = Q.commands[shortcut]
				command.help(shortcut, terms)
			else
				shortcut.to_s + ": unknown command"
			end
		end
		
		def help(shortcut, terms)
			([	%q{Usage: q [SHORTCUT] [TERM] ...},
				%q{Perform the command specified by SHORTCUT for the specified TERMs.},
				""
			] + Q.unique_commands.map{ |command| "  " + command.usage }.sort).join($/)
		end
	end
	
	register_command(:help, Help.new)
end