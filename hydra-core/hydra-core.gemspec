# -*- encoding: utf-8 -*-
version = File.read(File.expand_path("../../HYDRA_VERSION", __FILE__)).strip


Gem::Specification.new do |gem|
  gem.authors     = ["Matt Zumwalt, Bess Sadler, Julie Meloni, Naomi Dushay, Jessie Keck, John Scofield, Justin Coyne & many more.  See https://github.com/projecthydra/hydra-head/contributors"]
  gem.email       = ["hydra-tech@googlegroups.com"]
  gem.homepage    = "http://projecthydra.org"
  gem.summary     = %q{Hydra-Head Rails Engine (requires Rails3) }
  gem.description = %q{Hydra-Head is a Rails Engine containing the core code for a Hydra application. The full hydra stack includes: Blacklight, Fedora, Solr, active-fedora, solrizer, and om}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hydra-core"
  gem.require_paths = ["lib"]
  gem.version       = version
#  gem.required_ruby_version = '>= 1.9.3'


  gem.add_dependency "rails", '~>3.2.3' 
  gem.add_dependency "blacklight", '~>3.4'  
  gem.add_dependency "devise"
  gem.add_dependency "active-fedora", '~>4.6.0.rc2'
  gem.add_dependency 'RedCloth', '=4.2.9'
  gem.add_dependency 'block_helpers'
  gem.add_dependency 'sanitize'
  gem.add_dependency 'hydra-mods', ">= 0.0.5"
  gem.add_dependency 'deprecation', ">= 0.0.5"
  gem.add_dependency 'jquery-rails'
  gem.add_dependency 'hydra-access-controls', version
  
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'jettywrapper', ">=1.3.1"
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'cucumber-rails', '>=1.2.0'
  gem.add_development_dependency 'factory_girl_rails', '<2.0.0'  #>=2.0.0 requires ruby 1.9
  gem.add_development_dependency 'solrizer-fedora', '>=2.1.0'
end
