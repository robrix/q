module Q
	class Command
		def initialize(usage)
			@usage = usage
			@registered_shortcuts = []
		end
		
		
		def execute(shortcut, terms)
			"#{shortcut} is unimplemented"
		end
		
		def help(shortcut, terms)
			usage || "#{shortcut} is undocumented"
		end
		
		def usage
			registered_shortcuts.map{ |shortcut| shortcut.to_s }.join("|") + " " + @usage
		end
		
		attr_reader :registered_shortcuts
	end
end