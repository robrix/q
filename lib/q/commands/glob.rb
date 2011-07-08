module Q
	class Glob < Command
		def initialize(patterns)
			@patterns = patterns
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
		
		protected
		
		def interpolate_pattern(pattern, terms)
			pattern.gsub(/%\{(\d+?)\}/) do |match|
				terms[$1.to_i]
			end
		end
	end
	
	DOCSET_PATHS = [ # docsets to search within
		"/Library/Developer/Shared/Documentation/DocSets/*.docset",
		"/Developer/Documentation/DocSets/*.docset",
		"/Developer/Platforms/*.platform/Developer/Documentation/DocSets/*.docset"
	]
	DOCSET_CONTENTS_PATH = "/Contents/Resources/Documents/documentation/*/Reference/"
	PATTERNS = [ # these patterns are matched within <docset>/Contents/Resources/Documents/documentation/*/Reference/
		"%{0}%{1}/Reference/reference.html", # iPhone/CoreGraphics
		"%{0}%{1}Ref/index.html", # iPhone CoreFoundation
		"%{0}%{1}Ref/Reference/reference.html", # CoreFoundation
		"%{0}%{1}_Class/%{0}%{1}/%{0}%{1}.html", # iPhone/UIKit
		"%{0}%{1}_Class/%{0}%{1}ClassReference/%{0}%{1}ClassReference.html",
		"%{0}%{1}_Class/Introduction/Introduction.html",
		"%{0}%{1}_class/Reference/%{0}%{1}.html",
		"%{0}%{1}_class/Reference/Reference.html",
		"%{0}%{1}_ClassRef/Reference/%{0}%{1}.html", # iPhone/OpenGL ES
		"%{0}%{1}_protocol/Reference/%{0}%{1}.html",
		"%{0}%{1}_protocol/Reference/Reference.html",
		"*/Protocols/%{0}%{1}_protocol/Reference/Reference.html",
		"*/Classes/%{0}%{1}_Class/Introduction/Introduction.html",
		"*/Classes/%{0}%{1}_Class/Reference/%{0}%{1}.html",
		"*/Classes/%{0}%{1}_Class/Reference/Reference.html",
		"Foundation/Classes/%{0}%{1}_Class/Reference/Reference.html",
		"ManPages/man3/%{0}%{1}.3.html", # man pages, e.g. OpenGL man pages
		"*/Classes/%{0}%{1}_Class/%{0}%{1}.html",
		"*/Classes/%{0}%{1}_WebKitAdditions/Reference/Reference.html",
	]
	PATTERN_PATHS = (DOCSET_PATHS.reduce([]){ |memo, docset_path| memo + PATTERNS.collect{ |pattern| docset_path + DOCSET_CONTENTS_PATH + pattern } }).flatten
	
	PREFIXES = %w(ca cf cg dom eagl gl glu ib ns qt ui web)
	
	register_command(PREFIXES.collect{ |prefix| prefix.to_sym }, Glob.new(PATTERN_PATHS))
end
