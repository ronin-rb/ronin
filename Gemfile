source 'https://rubygems.org'

RONIN_URI  = 'https://github.com/ronin-rb'

gemspec

gem 'jruby-openssl',	'~> 0.7', platforms: :jruby

# Library dependencies
gem 'ronin-support',	'~> 0.6', git: "#{RONIN_URI}/ronin-support.git",
                                branch: '0.6.0'

gem 'ronin-repos', '~> 0.1', git: "#{RONIN_URI}/ronin-repos.git",
                             branch: 'main'

gem 'ronin-db', '~> 0.1', git: "#{RONIN_URI}/ronin-db.git",
                                branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.1'
  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'

  gem 'kramdown',        '~> 2.0'
  gem 'kramdown-man',    '~> 0.1'

  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'dead_end',        require: false
end
