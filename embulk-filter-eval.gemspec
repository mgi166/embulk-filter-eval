
Gem::Specification.new do |spec|
  spec.name          = "embulk-filter-eval"
  spec.version       = "0.1.0"
  spec.authors       = ["mgi166"]
  spec.summary       = "Eval filter plugin for Embulk"
  spec.description   = "Eval"
  spec.email         = ["skskoari@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/mgi166/embulk-filter-eval"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_development_dependency 'pry'
end
