module Q
	@@registered_commands = {}
	@@unique_commands = []
	
	def self.register_command(shortcut, command)
		if shortcut.is_a? Array
			shortcut.each do |s|
				register_command(s, command)
			end
		else
			@@registered_commands[shortcut.to_sym] = command
			@@unique_commands << command unless @@unique_commands.include? command
			command.registered_shortcuts << shortcut.to_sym
		end
	end
	
	def self.commands
		@@registered_commands
	end
	
	def self.unique_commands
		@@unique_commands
	end
	
	require "q/command"
	require "q/commands/glob"
	require "q/commands/help"
	require "q/commands/search"
	
	DEFAULT_SHORTCUT = :search
	SHORTCUT = if ARGV.empty?
		:help
	elsif @@registered_commands.has_key? ARGV.first.to_sym
		ARGV.shift.to_sym
	else
		DEFAULT_SHORTCUT
	end
	
	puts @@registered_commands[SHORTCUT].execute(SHORTCUT, ARGV)
end
