source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
DM_VERSION = '~> 1.0.2'

RONIN = 'http://github.com/ronin-ruby'

if ENV['EXTLIB']
  gem 'extlib',		'~> 0.9.15'
else
  gem 'tzinfo',		'~> 0.3.22'
  gem 'activesupport',	'~> 3.0.0', :require => 'active_support'
end

# DataMapper adapters
gem 'dm-do-adapter',		DM_VERSION
gem 'dm-sqlite-adapter',	DM_VERSION

# DataMapper dependencies
gem 'dm-core',		DM_VERSION
gem 'dm-types',		DM_VERSION
gem 'dm-constraints',	DM_VERSION
gem 'dm-migrations',	DM_VERSION, :git => 'http://github.com/postmodern/dm-migrations.git', :branch => 'runner'
gem 'dm-validations',	DM_VERSION
gem 'dm-aggregates',	DM_VERSION
gem 'dm-timestamps',	DM_VERSION
gem 'dm-tags',		DM_VERSION

# DataMapper plugins
gem 'dm-is-predefined',	'~> 0.3.0'

# Library dependencies
gem 'nokogiri',		'~> 1.4.1'
gem 'uri-query_params',	'~> 0.4.0'
gem 'open_namespace',	'~> 0.3.0'
gem 'parameters',	'~> 0.2.2'
gem 'data_paths',	'~> 0.2.1'
gem 'contextify',	'~> 0.1.6', :git => 'http://github.com/postmodern/contextify.git'
gem 'pullr',		'~> 0.1.2'
gem 'thor',		'~> 0.14.0', :git => 'http://github.com/postmodern/thor.git'
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"

group(:development) do
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.5.0.pre'
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
  gem 'yard',			'~> 0.6.0'
  gem 'yard-contextify',	'~> 0.1.0'
  gem 'yard-parameters',	'~> 0.1.0'
  gem 'yard-dm',		'~> 0.1.1'
  gem 'yard-dm-is-predefined',	'~> 0.2.0'
end

group(:test) do
  adapters = (ENV['ADAPTER'] || ENV['ADAPTERS'])
  adapters = adapters.to_s.gsub(',',' ').split(' ') - ['in_memory']

  DM_ADAPTERS = %w[sqlite3 postgres mysql oracle sqlserver]

  unless (DM_ADAPTERS & adapters).empty?
    adapters.each do |adapter|
      gem "dm-#{adapter}-adapter", DM_VERSION, :git => "#{DATA_MAPPER}/dm-#{adapter}-adapter.git"
    end
  end
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
