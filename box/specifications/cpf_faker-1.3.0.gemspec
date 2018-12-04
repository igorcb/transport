# -*- encoding: utf-8 -*-
# stub: cpf_faker 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cpf_faker".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bernardo de P\u00E1dua".freeze]
  s.date = "2011-06-26"
  s.description = "Generates brazilian CPF and CNPJ numbers for use in testing. Great to be used alongside Faker and won't clutter your namespace. ".freeze
  s.email = "berpasan@gmail.com".freeze
  s.executables = ["cnpj".freeze, "cpf".freeze]
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.rdoc".freeze]
  s.files = ["LICENSE.txt".freeze, "README.rdoc".freeze, "bin/cnpj".freeze, "bin/cpf".freeze]
  s.homepage = "http://github.com/bernardo/cpf_faker".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Generate fake brasilian CPF and CNPJ numbers for test purposes".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<clipboard>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.1.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>.freeze, [">= 0"])
      s.add_development_dependency(%q<br-cpf>.freeze, [">= 0"])
      s.add_development_dependency(%q<br-cnpj>.freeze, [">= 0"])
    else
      s.add_dependency(%q<clipboard>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.1.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>.freeze, [">= 0"])
      s.add_dependency(%q<br-cpf>.freeze, [">= 0"])
      s.add_dependency(%q<br-cnpj>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<clipboard>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>.freeze, [">= 0"])
    s.add_dependency(%q<br-cpf>.freeze, [">= 0"])
    s.add_dependency(%q<br-cnpj>.freeze, [">= 0"])
  end
end
