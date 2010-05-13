source 'http://rubygems.org'
ronin_ruby = "git://github.com/ronin-ruby"

group :runtime do
  gem 'nokogiri',	'~> 1.4.1'
  gem 'extlib',		'~> 0.9.14'
  gem 'data_objects',	'~> 0.10.1'
  gem 'do_sqlite3',	'~> 0.10.1'
  gem 'dm-core',	'~> 0.10.2'
  gem 'dm-types',	'~> 0.10.2'
  gem 'dm-validations',	'~> 0.10.2'
  gem 'dm-aggregates',	'~> 0.10.2'
  gem 'dm-timestamps',	'~> 0.10.2'
  gem 'dm-tags',	'~> 0.10.1'
  gem 'dm-predefined',	'~> 0.2.3'
  gem 'open_namespace',	'~> 0.3.0'
  gem 'parameters',	'~> 0.2.1'
  gem 'data_paths',	'~> 0.2.1'
  gem 'contextify',	'~> 0.1.5'
  gem 'pullr',		'~> 0.1.2'
  gem 'thor',		'~> 0.13.0'
  gem 'ronin-support',	'~> 0.1.0', :git => "#{ronin_ruby}/ronin-support.git"
end

group :development do
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.4.0', :git => 'git://github.com/technicalpickles/jeweler.git'
end

group :doc do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'ruby-graphviz',		'~> 0.9.10'
  gem 'dm-visualizer',		'~> 0.1.0', :git => 'git://github.com/postmodern/dm-visualizer.git'
  gem 'yard',			'~> 0.5.3'
  gem 'yard-contextify',	'~> 0.1.0', :git => 'git://github.com/postmodern/yard-contextify.git'
  gem 'yard-parameters',	'~> 0.1.0'
  gem 'yard-dm',		'~> 0.1.1'
  gem 'yard-dm-predefined',	'~> 0.1.0'
end

gem 'rspec',	'~> 1.3.0', :group => [:development, :test]
