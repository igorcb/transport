# -*- encoding: utf-8 -*-
# stub: odf-report 0.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "odf-report".freeze
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sandro Duarte".freeze]
  s.date = "2017-12-07"
  s.description = "Generates ODF files, given a template (.odt) and data, replacing tags".freeze
  s.email = "sandrods@gmail.com".freeze
  s.homepage = "http://sandrods.github.com/odf-report/".freeze
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Generates ODF files, given a template (.odt) and data, replacing tags".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_development_dependency(%q<faker>.freeze, [">= 0"])
      s.add_development_dependency(%q<launchy>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rubyzip>.freeze, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.5.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
      s.add_dependency(%q<faker>.freeze, [">= 0"])
      s.add_dependency(%q<launchy>.freeze, [">= 0"])
      s.add_dependency(%q<rubyzip>.freeze, ["~> 1.2.0"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
    s.add_dependency(%q<faker>.freeze, [">= 0"])
    s.add_dependency(%q<launchy>.freeze, [">= 0"])
    s.add_dependency(%q<rubyzip>.freeze, ["~> 1.2.0"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.5.0"])
  end
end
