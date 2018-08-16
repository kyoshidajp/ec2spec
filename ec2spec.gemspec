lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2spec/version'
Gem::Specification.new do |spec|
  spec.name          = 'ec2spec'
  spec.version       = Ec2spec::VERSION
  spec.authors       = %w["Katsuhiko YOSHIDA"]
  spec.email         = %w[claddvd@gmail.com]

  spec.description   = 'ec2spec is a simple comparison tool for Amazon EC2 Instances you can access.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/kyoshidajp/ec2spec'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'specinfra'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'thor'
  spec.add_dependency 'money'
  spec.add_dependency 'money-open-exchange-rates'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
