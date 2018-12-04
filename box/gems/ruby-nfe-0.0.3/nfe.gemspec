# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nfe/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-nfe"
  spec.version       = NFe::VERSION
  spec.authors       = ["Igor C. Batista"]
  spec.email         = ["igor.batista@gmail.com"]

  spec.summary       = %q{Consulta arquivo XML da Sefaz.}
  spec.description   = %q{Consulta arquivo XML da Sefaz e serealiza em objeto.}
  spec.homepage      = "https://github.com/igorcb/ruby-nfe"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "https://rubygems.org"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end
  
  spec.files       = Dir["{lib/**/*.rb,README.rdoc,test/**/*.rb,Rakefile,*.gemspec}"]
  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  #spec.files = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  #spec.require_paths = Dir['lib/**/*.rb']

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "roxml", "~> 3.3"
end
