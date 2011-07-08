module Q
	class Search < Command
		def initialize(url_pattern, usage)
			@url_pattern = url_pattern
			super(usage)
		end
		
		
		def execute(shortcut, terms)
			url = @url_pattern % terms.join("+")
			%x{osascript -e 'open location "#{url}"'}
			url
		end
	end
	
	register_command([:search, :google, :g], Search.new("http://www.google.com/search?q=%s", "TERM ... -- search for TERMs on google"))
	register_command([:ruby, :rb], Search.new("http://ruby-doc.org/core/classes/%s.html", "CLASS -- look up CLASS on ruby-doc.org"))
	register_command([:wikipedia, :wp], Search.new("http://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go", "ARTICLE -- look up [article] on wikipedia"))
end