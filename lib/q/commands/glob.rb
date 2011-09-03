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
		`xcode-select -print-path`.strip + "/Platforms/*.platform/Developer/Documentation/DocSets/*.docset",
		`xcode-select -print-path`.strip + "/Documentation/DocSets/*.docset",
		"/Library/Developer/Documentation/DocSets/*.docset",
		"/Library/Developer/Shared/Documentation/DocSets/*.docset",
	].reverse
	DOCSET_CONTENTS_PATH = "/Contents/Resources/Documents/documentation/*/Reference"
	PATTERNS = [
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/Reference/Reference.html",
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/Reference/%0%1.html",
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/Introduction/Introduction.html",
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/%0%1.html",
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/%0%1/%0%1.html",
		"{,/*/*}/%0%1{_Class,_ClassRef,_Protocol,Ref}/%0%1ClassReference/%0%1ClassReference.html",
		"/*/Classes/%0%1_WebKitAdditions/Reference/Reference.html",
	]
	PATTERN_PATHS = (DOCSET_PATHS.reduce([]){ |memo, docset_path| memo + PATTERNS.collect{ |pattern| docset_path + DOCSET_CONTENTS_PATH + pattern } }).flatten
	
	PREFIXES = %w(ca cf cg dom eagl ib ns qt ui web)
	
	register_command(PREFIXES.collect{ |prefix| prefix.to_sym }, Glob.new(PATTERN_PATHS, "CLASS -- glob through Cocoa documentation for CLASS"))
end
