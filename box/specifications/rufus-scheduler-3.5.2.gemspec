# -*- encoding: utf-8 -*-
# stub: rufus-scheduler 3.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rufus-scheduler".freeze
  s.version = "3.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/jmettraux/rufus-scheduler/issues", "changelog_uri" => "http://github.com/jmettraux/rufus-scheduler/blob/master/CHANGELOG.md", "homepage_uri" => "http://github.com/jmettraux/rufus-scheduler", "source_code_uri" => "http://github.com/jmettraux/rufus-scheduler" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Mettraux".freeze]
  s.date = "2018-07-31"
  s.description = "Job scheduler for Ruby (at, cron, in and every jobs). Not a replacement for crond.".freeze
  s.email = ["jmettraux@gmail.com".freeze]
  s.homepage = "http://github.com/jmettraux/rufus-scheduler".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubyforge_project = "rufus".freeze
  s.rubygems_version = "2.7.8".freeze
  s.summary = "job scheduler for Ruby (at, cron, in and every jobs)".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fugit>.freeze, ["~> 1.1", ">= 1.1.5"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_development_dependency(%q<chronic>.freeze, ["~> 0.10"])
    else
      s.add_dependency(%q<fugit>.freeze, ["~> 1.1", ">= 1.1.5"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_dependency(%q<chronic>.freeze, ["~> 0.10"])
    end
  else
    s.add_dependency(%q<fugit>.freeze, ["~> 1.1", ">= 1.1.5"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
    s.add_dependency(%q<chronic>.freeze, ["~> 0.10"])
  end
end
