# -*- encoding: utf-8 -*-
# stub: extensobr 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "extensobr".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Henrique Max".freeze]
  s.bindir = "exe".freeze
  s.date = "2016-11-30"
  s.description = "ExtensoBr \u00E9 uma gem que foi desenvolvida para auxiliar na impress\u00E3o de n\u00FAmeros e moedas por extenso em portug\u00EAs do Brasil.".freeze
  s.email = ["rickmaxg3@hotmail.com".freeze]
  s.homepage = "https://github.com/rickmax/extensobr".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "ExtendoBr escreve n\u00FAmeros e moeda por extenso.".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
