module Q
	class Glob < Command
		def initialize(patterns, usage)
			@patterns = patterns
			super(usage)
		end
		
		def execute(shortcut, terms)
			matches = []
			@patterns.each do |pattern|
				matches = Dir.glob(interpolate_pattern(pattern, [shortcut.to_s] + terms))
				unless matches.empty?
					%x{open -a Safari "#{matches.first}"}
					break
				end
			end
			matches.first
		end
		
		def help(shortcut, terms)
			short = usage
			if terms.include?("-v") or terms.include?("--verbose")
				long = $/ + @patterns.join($/) + $/ + $/ + "(%0, %1, ... are replaced with the shortcut and terms)"
				short + $/ + long
			else
				short + $/ + "(use `q help #{shortcut} --verbose` or `q help #{shortcut} -v` for the relevant patterns)"
			end
		end
		
		protected
		
		def interpolate_pattern(pattern, terms)
			pattern.gsub(/%(\d+)/) do |match|
				terms[$1.to_i]
			end
		end
	end
	
	DOCSET_PATHS = [ # docsets to search within
		`xcode-select -print-path`.strip + "/Documentation/DocSets/*.docset",
		`xcode-select -print-path`.strip + "/Platforms/*.platform/Developer/Documentation/DocSets/*.docset",
		"/Library/Developer/Documentation/DocSets/*.docset",
	]
	DOCSET_CONTENTS_PATH = "/Contents/Resources/Documents/documentation/*/Reference/"
	PATTERNS = [ # these patterns are matched within <docset>/Contents/Resources/Documents/documentation/*/Reference/
		"%0%1/Reference/reference.html", # iPhone/CoreGraphics
		"%0%1Ref/index.html", # iPhone CoreFoundation
		"%0%1Ref/Reference/reference.html", # CoreFoundation
		"%0%1_Class/%0%1/%0%1.html", # iPhone/UIKit
		"%0%1_Class/%0%1ClassReference/%0%1ClassReference.html",
		"%0%1_Class/Introduction/Introduction.html",
		"%0%1_class/Reference/%0%1.html",
		"%0%1_class/Reference/Reference.html",
		"%0%1_ClassRef/Reference/%0%1.html", # iPhone/OpenGL ES
		"%0%1_protocol/Reference/%0%1.html",
		"%0%1_protocol/Reference/Reference.html",
		"*/*/%0%1_*/Reference/Reference.html",
		"*/*/%0%1_*/Introduction/Introduction.html",
		"*/*/%0%1_*/Reference/%0%1.html",
		"*/*/%0%1_*/%0%1.html",
		"ManPages/man3/%0%1.3.html", # man pages, e.g. OpenGL man pages
		"*/Classes/%0%1_WebKitAdditions/Reference/Reference.html",
	]
	PATTERN_PATHS = (DOCSET_PATHS.reduce([]){ |memo, docset_path| memo + PATTERNS.collect{ |pattern| docset_path + DOCSET_CONTENTS_PATH + pattern } }).flatten
	
	PREFIXES = %w(ca cf cg dom eagl gl glu ib ns qt ui web)
	
	register_command(PREFIXES.collect{ |prefix| prefix.to_sym }, Glob.new(PATTERN_PATHS, "CLASS -- glob through Cocoa documentation for CLASS"))
end
