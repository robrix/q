Gem::Specification.new do |s|
	s.name = %q{qtool} # there is already a q on rubygems.org
	s.version = "0.1.0"
	s.date = %q{2011-07-08}
	s.authors = ["Rob Rix"]
	s.email = %q{rob@monochromeindustries.com}
	s.summary = %q{q is for query.}
	s.homepage = %q{https://github.com/robrix/q/}
	s.description = %q{Automate bits of your everyday workflow with q commands.}
	s.files = `git ls-files`.split($/) - ["q.gemspec"]
	s.executables = %w(q)
	s.require_path = 'lib'
end
