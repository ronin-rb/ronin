source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
RONIN = 'http://github.com/ronin-ruby'

if ENV['EXTLIB']
  gem 'extlib',		'~> 0.9.15'
else
  gem 'tzinfo',		'~> 0.3.22'
  gem 'activesupport',	'~> 3.0.0.rc', :require => 'active_support'
end

# DataMapper adapters
gem 'dm-do-adapter',		'~> 1.0.0'
gem 'dm-sqlite-adapter',	'~> 1.0.0'

# DataMapper dependencies
gem 'dm-core',		'~> 1.0.0', :git => "#{DATA_MAPPER}/dm-core.git"
gem 'dm-types',		'~> 1.0.0'
gem 'dm-constraints',	'~> 1.0.0'
gem 'dm-migrations',	'~> 1.0.0', :git => 'http://github.com/postmodern/dm-migrations.git', :branch => 'runner'
gem 'dm-validations',	'~> 1.0.0'
gem 'dm-aggregates',	'~> 1.0.0'
gem 'dm-timestamps',	'~> 1.0.0'
gem 'dm-tags',		'~> 1.0.0'

# DataMapper plugins
gem 'dm-is-predefined',	'~> 0.3.0'

# Library dependencies
gem 'nokogiri',		'~> 1.4.1'
gem 'open_namespace',	'~> 0.3.0'
gem 'parameters',	'~> 0.2.2'
gem 'data_paths',	'~> 0.2.1'
gem 'contextify',	'~> 0.1.6', :git => 'http://github.com/postmodern/contextify.git'
gem 'pullr',		'~> 0.1.2'
gem 'thor',		'~> 0.14.0'
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"

group(:development) do
  gem 'bundler',		'~> 1.0.0'
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.5.0', :git => 'http://github.com/technicalpickles/jeweler.git'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'ruby-graphviz',		'~> 0.9.10'
  gem 'dm-visualizer',		'~> 0.1.0'
  gem 'yard',			'~> 0.5.3'
  gem 'yard-contextify',	'~> 0.1.0'
  gem 'yard-parameters',	'~> 0.1.0'
  gem 'yard-dm',		'~> 0.1.1'
  gem 'yard-dm-is-predefined',	'~> 0.2.0'
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
