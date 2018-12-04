# -*- encoding: utf-8 -*-
# stub: ruby-nfe 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-nfe".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Igor C. Batista".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-05-10"
  s.description = "Consulta arquivo XML da Sefaz e serealiza em objeto.".freeze
  s.email = ["igor.batista@gmail.com".freeze]
  s.homepage = "https://github.com/igorcb/ruby-nfe".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Consulta arquivo XML da Sefaz.".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<roxml>.freeze, ["~> 3.3"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<roxml>.freeze, ["~> 3.3"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<roxml>.freeze, ["~> 3.3"])
  end
end
