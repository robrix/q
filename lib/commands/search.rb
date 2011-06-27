module Q
	class Search < Command
		def initialize(url_pattern)
			@url_pattern = url_pattern
		end
		
		
		def execute(shortcut, terms)
			url = @url_pattern % terms.join("+")
			%x{osascript -e 'open location "#{url}"'}
			url
		end
	end
	
	register_command([:search, :google, :g], Search.new("http://www.google.com/search?q=%s"))
	register_command([:ruby, :rb], Search.new("http://ruby-doc.org/core/classes/%s.html"))
	register_command([:wikipedia, :wp], Search.new("http://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go"))
end