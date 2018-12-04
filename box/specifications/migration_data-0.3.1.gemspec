# -*- encoding: utf-8 -*-
# stub: migration_data 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "migration_data".freeze
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrey Koleshko".freeze]
  s.date = "2018-10-11"
  s.description = "Sometimes we have to write some Rails code in the migrations and it's hard to\n                          keep them in working state because models wich are used there changes too often. there\n                          some techniques which help to avoid these pitfalls. For example, define model\n                          classes in the migrations or write raw SQL. But they don't help in 100% cases anyway.\n                          This gem promises to solve the problem in a simple way.".freeze
  s.email = ["ka8725@gmail.com".freeze]
  s.homepage = "http://railsguides.net/change-data-in-migrations-like-a-boss/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Provides possibility to write any code in migrations safely without regression.".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
