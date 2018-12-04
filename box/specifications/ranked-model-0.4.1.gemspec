# -*- encoding: utf-8 -*-
# stub: ranked-model 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ranked-model".freeze
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Beale".freeze]
  s.date = "2018-07-12"
  s.description = "ranked-model is a modern row sorting library built for Rails 3 & 4. It uses ARel aggressively and is better optimized than most other libraries.".freeze
  s.email = ["matt.beale@madhatted.com".freeze]
  s.homepage = "https://github.com/mixonic/ranked-model".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "An acts_as_sortable replacement built for Rails 3 & 4".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.1.12"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.13.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3.7"])
      s.add_development_dependency(%q<genspec>.freeze, ["~> 0.2.8"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 0.14.0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 1.2.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.1.0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 3.1.12"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.13.0"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.7"])
      s.add_dependency(%q<genspec>.freeze, ["~> 0.2.8"])
      s.add_dependency(%q<mocha>.freeze, ["~> 0.14.0"])
      s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.2.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.1.0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.1.12"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.13.0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.7"])
    s.add_dependency(%q<genspec>.freeze, ["~> 0.2.8"])
    s.add_dependency(%q<mocha>.freeze, ["~> 0.14.0"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.1.0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
