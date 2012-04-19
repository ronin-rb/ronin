source 'https://rubygems.org'

DM_URI     = 'http://github.com/datamapper'
DM_VERSION = '~> 1.2'
DO_VERSION = '~> 0.10.3'
RONIN_URI  = 'http://github.com/ronin-ruby'

gemspec

platforms :jruby do
  gem 'jruby-openssl',	'~> 0.7'
end

# DataMapper dependencies
# gem 'data_objects',       DO_VERSION, :git => "#{DM_URI}/do.git"
# gem 'do_sqlite3',         DO_VERSION, :git => "#{DM_URI}/do.git"
# gem 'dm-do-adapter',      DM_VERSION, :git => "#{DM_URI}/dm-do-adapter.git"
# gem 'dm-sqlite-adapter',  DM_VERSION, :git => "#{DM_URI}/dm-sqlite-adapter.git"
# gem 'dm-core',            DM_VERSION, :git => "#{DM_URI}/dm-core.git"
# gem 'dm-types',           DM_VERSION, :git => "#{DM_URI}/dm-types.git"
# gem 'dm-constraints',     DM_VERSION, :git => "#{DM_URI}/dm-constraints.git"
# gem 'dm-migrations',      DM_VERSION, :git => "#{DM_URI}/dm-migrations.git"
# gem 'dm-validations',     DM_VERSION, :git => "#{DM_URI}/dm-validations.git"
# gem 'dm-serializer',      DM_VERSION, :git => "#{DM_URI}/dm-serializer.git"
# gem 'dm-aggregates',      DM_VERSION, :git => "#{DM_URI}/dm-aggregates.git"
# gem 'dm-timestamps',      DM_VERSION, :git => "#{DM_URI}/dm-timestamps.git"

# Library dependencies
# gem 'ronin-support',	'~> 0.4.0.rc1', :git => "#{RONIN_URI}/ronin-support.git"

group :development do
  gem 'rake',           '~> 0.8'
  gem 'rubygems-tasks', '0.1.0.pre1'
  gem 'rspec',          '~> 2.4'
  gem 'kramdown',       '~> 0.12'
  gem 'ruby-graphviz',  '~> 0.9'
  gem 'dm-visualizer',  '~> 0.2'
end

#
# To enable additional DataMapper adapters for development work or for
# testing purposes, simple set the ADAPTER or ADAPTERS environment
# variable:
#
#     export ADAPTER="postgres"
#     bundle install
#
#     ./bin/ronin --database postgres://ronin@localhost/ronin
#
require 'set'

DM_ADAPTERS = Set['postgres', 'mysql', 'oracle', 'sqlserver']

adapters = (ENV['ADAPTER'] || ENV['ADAPTERS']).to_s
adapters = Set.new(adapters.to_s.tr(',',' ').split)

(DM_ADAPTERS & adapters).each do |adapter|
  gem "dm-#{adapter}-adapter", DM_VERSION #, :git => "#{DM_URI}/dm-#{adapter}-adapter.git"
end
