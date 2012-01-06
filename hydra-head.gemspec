# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hydra-head/version"

Gem::Specification.new do |s|
  s.name        = "hydra-head"
  s.version     = HydraHead::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Zumwalt, Bess Sadler, Julie Meloni, Naomi Dushay, Jessie Keck, John Scofield, Justin Coyne & many more.  See https://github.com/projecthydra/hydra-head/contributors"]
  s.email       = ["hydra-tech@googlegroups.com"]
  s.homepage    = "http://projecthydra.org"
  s.summary     = %q{Hydra-Head Rails Engine (requires Rails3) }
  s.description = %q{Hydra-Head is a Rails Engine containing the core code for a Hydra application. The full hydra stack includes: Blacklight, Fedora, Solr, active-fedora, solrizer, and om}

  s.add_dependency "rails", '~> 3.0.10'
  s.add_dependency "rsolr", '1.0.2' ## version 1.0.6 breaks when using blacklight 3.0.0
  s.add_dependency "blacklight", '3.0.0'  
  s.add_dependency "active-fedora", '>=3.2.0.pre6'
  s.add_dependency 'builder', '2.1.2'
  s.add_dependency 'columnize'
  s.add_dependency 'crack'
  s.add_dependency 'curb', '0.7.15' ##Locked here because centos 5.2 (Hudson) doesn't support curl 7.16
  s.add_dependency 'database_cleaner'
  s.add_dependency 'diff-lcs'
  s.add_dependency 'facets', '2.8.4'
  s.add_dependency 'haml'
  s.add_dependency 'httparty'
  s.add_dependency 'json_pure', '>1.4.3'
  s.add_dependency 'launchy'
  s.add_dependency 'linecache'
  s.add_dependency 'mime-types'
  s.add_dependency 'mediashelf-loggable', "=0.4.7" # Solrizer defines this dependency but its' gemspec needs to be updated.  Until then we'll require 0.4.7.
  s.add_dependency 'multipart-post'
  s.add_dependency 'nokogiri' # Default to using the version required by Blacklight
  s.add_dependency 'om', '>=1.2.3'
  s.add_dependency 'rack'
  s.add_dependency 'rack-test'
  s.add_dependency 'rake'
  s.add_dependency 'RedCloth', '=4.2.3'
  s.add_dependency 'solr-ruby' 
  s.add_dependency 'mediashelf-loggable', '>=0.4.7' ##This can be removed once this dependency is declared in solrizer
  s.add_dependency 'solrizer', '>=1.1.0'
  s.add_dependency 'solrizer-fedora', '>=1.2.2'
  s.add_dependency 'sqlite3', '>=1.2.5'
  s.add_dependency 'term-ansicolor'
  s.add_dependency 'trollop'
  s.add_dependency 'will_paginate'
  s.add_dependency 'xml-simple'
  s.add_dependency 'block_helpers'
  s.add_dependency 'sanitize'
  
  s.add_development_dependency 'yard'
  s.add_development_dependency 'jettywrapper', ">=1.0.4"
  s.add_development_dependency 'ruby-debug'
  s.add_development_dependency 'ruby-debug-base'
#  s.add_development_dependency 'rspec', '>= 2.0.0'  
  s.add_development_dependency 'rspec-rails', '>= 2.7.0'
#  s.add_development_dependency 'rest-client'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'cucumber', '>=0.8.5'
  s.add_development_dependency 'cucumber-rails', '>=1.0.0'
  s.add_development_dependency 'gherkin'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency "rake"


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
