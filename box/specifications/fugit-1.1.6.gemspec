# -*- encoding: utf-8 -*-
# stub: fugit 1.1.6 ruby lib

Gem::Specification.new do |s|
  s.name = "fugit".freeze
  s.version = "1.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/floraison/fugit/issues", "changelog_uri" => "http://github.com/floraison/fugit/blob/master/CHANGELOG.md", "documentation_uri" => "http://github.com/floraison/fugit", "homepage_uri" => "http://github.com/floraison/fugit", "source_code_uri" => "http://github.com/floraison/fugit" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Mettraux".freeze]
  s.date = "2018-09-04"
  s.description = "Time tools for flor and the floraison project. Cron parsing and occurrence computing. Timestamps and more.".freeze
  s.email = ["jmettraux+flor@gmail.com".freeze]
  s.homepage = "http://github.com/floraison/fugit".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "time tools for flor".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<raabro>.freeze, ["~> 1.1"])
      s.add_runtime_dependency(%q<et-orbi>.freeze, ["~> 1.1", ">= 1.1.6"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7"])
    else
      s.add_dependency(%q<raabro>.freeze, ["~> 1.1"])
      s.add_dependency(%q<et-orbi>.freeze, ["~> 1.1", ">= 1.1.6"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
    end
  else
    s.add_dependency(%q<raabro>.freeze, ["~> 1.1"])
    s.add_dependency(%q<et-orbi>.freeze, ["~> 1.1", ">= 1.1.6"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
  end
end
