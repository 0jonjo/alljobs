# -*- encoding: utf-8 -*-
# stub: rubycritic 4.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubycritic".freeze
  s.version = "4.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Guilherme Simoes".freeze]
  s.date = "2023-10-18"
  s.description = "RubyCritic is a tool that wraps around various static analysis gems to provide a quality report of your Ruby code.".freeze
  s.email = ["guilherme.rdems@gmail.com".freeze]
  s.executables = ["rubycritic".freeze]
  s.files = ["bin/rubycritic".freeze]
  s.homepage = "https://github.com/whitesmith/rubycritic".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "RubyCritic is a Ruby code quality reporter".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<flay>.freeze, ["~> 2.13"])
  s.add_runtime_dependency(%q<flog>.freeze, ["~> 4.7"])
  s.add_runtime_dependency(%q<launchy>.freeze, [">= 2.5.2"])
  s.add_runtime_dependency(%q<parser>.freeze, [">= 3.2.2.1"])
  s.add_runtime_dependency(%q<rainbow>.freeze, ["~> 3.1.1"])
  s.add_runtime_dependency(%q<reek>.freeze, ["~> 6.0", "< 7.0"])
  s.add_runtime_dependency(%q<rexml>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ruby_parser>.freeze, ["~> 3.20"])
  s.add_runtime_dependency(%q<simplecov>.freeze, [">= 0.22.0"])
  s.add_runtime_dependency(%q<tty-which>.freeze, ["~> 0.5.0"])
  s.add_runtime_dependency(%q<virtus>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<aruba>.freeze, ["~> 2.2.0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 2.0.0"])
  s.add_development_dependency(%q<byebug>.freeze, ["~> 11.0", ">= 10.0"])
  s.add_development_dependency(%q<cucumber>.freeze, ["~> 9.0.2", "!= 9.0.0"])
  s.add_development_dependency(%q<diff-lcs>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<fakefs>.freeze, ["~> 2.5.0"])
  s.add_development_dependency(%q<mdl>.freeze, ["~> 0.13.0", ">= 0.12.0"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.20.0", ">= 5.3.0"])
  s.add_development_dependency(%q<minitest-around>.freeze, ["~> 0.5.0", ">= 0.4.0"])
  s.add_development_dependency(%q<mocha>.freeze, ["~> 2.1.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0.6", ">= 11.0.0"])
  s.add_development_dependency(%q<rexml>.freeze, [">= 3.2.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.57.1", ">= 1.54.0"])
  s.add_development_dependency(%q<rubocop-minitest>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop-rake>.freeze, [">= 0"])
end
