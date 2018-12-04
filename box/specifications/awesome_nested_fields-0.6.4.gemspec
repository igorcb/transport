# -*- encoding: utf-8 -*-
# stub: awesome_nested_fields 0.6.4 ruby lib

Gem::Specification.new do |s|
  s.name = "awesome_nested_fields".freeze
  s.version = "0.6.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lailson Bandeira".freeze]
  s.date = "2013-02-17"
  s.description = "Awesome dynamic nested fields for Rails and jQuery".freeze
  s.email = "lailson@guava.com.br".freeze
  s.homepage = "http://rubygems.org/gems/awesome_nested_fields".freeze
  s.rubyforge_project = "awesome_nested_fields".freeze
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Awesome nested fields for Rails".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 2"])
      s.add_development_dependency(%q<turn>.freeze, ["~> 0.8.3"])
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3.0.0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 2"])
      s.add_dependency(%q<turn>.freeze, ["~> 0.8.3"])
      s.add_dependency(%q<rails>.freeze, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 2"])
    s.add_dependency(%q<turn>.freeze, ["~> 0.8.3"])
    s.add_dependency(%q<rails>.freeze, [">= 3.0.0"])
  end
end
