# -*- encoding: utf-8 -*-
# stub: enumerize 2.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "enumerize".freeze
  s.version = "2.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sergey Nartimov".freeze]
  s.date = "2018-03-06"
  s.description = "Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support".freeze
  s.email = "team@brainspec.com".freeze
  s.homepage = "https://github.com/brainspec/enumerize".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.2"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 3.2"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 3.2"])
  end
end
