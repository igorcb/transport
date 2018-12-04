# -*- encoding: utf-8 -*-
# stub: thinreports-rails 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "thinreports-rails".freeze
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Takeshi Shinoda".freeze]
  s.date = "2017-08-14"
  s.description = "Rails plugin for ThinReports DSL. This plugin can write DSL to View.".freeze
  s.email = ["takeshinoda@gmail.com".freeze]
  s.homepage = "https://github.com/takeshinoda/thinreports-rails".freeze
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Rails plugin for ThinReports DSL.".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thinreports>.freeze, [">= 0.10"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.7"])
    else
      s.add_dependency(%q<thinreports>.freeze, [">= 0.10"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.7"])
    end
  else
    s.add_dependency(%q<thinreports>.freeze, [">= 0.10"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.7"])
  end
end
