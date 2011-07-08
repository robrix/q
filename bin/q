#!/usr/bin/env ruby

module Q
	@@registered_commands = {}
	
	def self.register_command(shortcut, command)
		if shortcut.is_a? Array
			shortcut.each do |s|
				register_command(s, command)
			end
		else
			@@registered_commands[shortcut.to_sym] = command
		end
	end

	require "lib/command"
	require "lib/commands/glob"
	require "lib/commands/search"
	
	DEFAULT_SHORTCUT = :search
	SHORTCUT = if @@registered_commands.has_key? ARGV.first.to_sym
		ARGV.shift.to_sym
	else
		DEFAULT_SHORTCUT
	end
	
	puts @@registered_commands[SHORTCUT].execute(SHORTCUT, ARGV)
end
