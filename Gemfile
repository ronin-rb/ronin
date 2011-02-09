require 'ore/specification'

source 'https://rubygems.org'

DATA_MAPPER = 'http://github.com/datamapper'
DM_VERSION = '~> 1.0.2'
RONIN = 'http://github.com/ronin-ruby'

gemspec

# Library dependencies
# gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"

group :development do
  gem 'rake',         '~> 0.8.7'

  gem 'ore-core',     '~> 0.1.1'
  gem 'ore-tasks',    '~> 0.3.0'
  gem 'rspec',        '~> 2.4.0'

  gem 'kramdown',       '~> 0.12.0'
  gem 'ruby-graphviz',  '~> 0.9.10'
  gem 'dm-visualizer',  '~> 0.2.0'
end

group :test do
  adapters = (ENV['ADAPTER'] || ENV['ADAPTERS'])
  adapters = adapters.to_s.gsub(',',' ').split(' ') - ['in_memory']

  DM_ADAPTERS = %w[sqlite3 postgres mysql oracle sqlserver]

  unless (DM_ADAPTERS & adapters).empty?
    adapters.each do |adapter|
      gem "dm-#{adapter}-adapter", DM_VERSION, :git => "#{DATA_MAPPER}/dm-#{adapter}-adapter.git"
    end
  end
end
