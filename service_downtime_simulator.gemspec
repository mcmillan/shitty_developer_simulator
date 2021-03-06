lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_downtime_simulator'

Gem::Specification.new do |spec|
  spec.name          = 'service_downtime_simulator'
  spec.version       = ServiceDowntimeSimulator::VERSION
  spec.authors       = ['Josh McMillan']
  spec.email         = ['joshua.mcmillan@deliveroo.co.uk']

  spec.summary       = "Want to know what it's like to have me in your dev team? This gem is for you!"
  spec.homepage      = 'https://github.com/deliveroo/service_downtime_simulator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
