# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nagios/zfs/version'

Gem::Specification.new do |spec|
  spec.name          = 'nagios-zfs'
  spec.version       = Nagios::ZFS::VERSION
  spec.authors       = ['Björn Albers']
  spec.email         = ['bjoernalbers@googlemail.com']
  spec.description   = 'Check ZFS Zpool health and capacity via Nagios.'
  spec.summary       = "#{spec.name}-#{spec.version}"
  spec.homepage      = 'https://github.com/bjoernalbers/nagios-zfs'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'guard-cucumber'
  spec.add_development_dependency 'guard-rspec'
end
