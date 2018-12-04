# -*- encoding: utf-8 -*-
# stub: bootstrap-addons-rails 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-addons-rails".freeze
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kristian Mandrup".freeze]
  s.date = "2013-03-15"
  s.description = "Adds nice Bootstrap addons to your Rails Twitter Bootstrap based app".freeze
  s.email = "kmandrup@gmail.com".freeze
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "http://github.com/kristianmandrup/bootstrap-addons-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Twitter Bootstrap addons: Color- and Datepicker, Image gallery, ready for use with Rails asset pipeline".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 2.8.0"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 3.12"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>.freeze, [">= 1.8.3"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0.5"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 2.8.0"])
      s.add_dependency(%q<rdoc>.freeze, [">= 3.12"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 1.8.3"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0.5"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 2.8.0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 3.12"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 1.8.3"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0.5"])
  end
end
