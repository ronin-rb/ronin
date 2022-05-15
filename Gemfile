source 'https://rubygems.org'

gemspec

gem 'jruby-openssl',	'~> 0.7', platforms: :jruby

gem 'net-telnet', '~> 0.1', group: :net
if RUBY_VERSION >= '3.1.0'
  gem 'net-ftp',    '~> 0.1', group: :net, platform: :mri
  gem 'net-smtp',   '~> 0.1', group: :net, platform: :mri
  gem 'net-pop',    '~> 0.1', group: :net, platform: :mri
  gem 'net-imap',   '~> 0.1', group: :net, platform: :mri
end

# Library dependencies
gem 'ronin-support',	       '~> 1.0', github: "ronin-rb/ronin-support",
                                       branch: '1.0.0'
gem 'ronin-core',            '~> 0.1', github: "ronin-rb/ronin-core",
                                       branch: 'main'
gem 'ronin-repos',           '~> 0.1', github: "ronin-rb/ronin-repos",
                                       branch: 'main'
gem 'ronin-db',              '~> 0.1', github: "ronin-rb/ronin-db",
                                       branch: 'main'
gem 'ronin-db-activerecord', '~> 0.1', github: "ronin-rb/ronin-db-activerecord",
                                       branch: 'main'
gem 'ronin-fuzzer',          '~> 0.1', github: "ronin-rb/ronin-fuzzer",
                                       branch: 'main'
gem 'ronin-post_ex',         '~> 0.1', github: "ronin-rb/ronin-post_ex",
                                       branch: 'main'
gem 'ronin-payloads',        '~> 0.1', github: "ronin-rb/ronin-payloads",
                                       branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.1'
  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'

  gem 'kramdown',        '~> 2.0'
  gem 'kramdown-man',    '~> 0.1'

  gem 'redcarpet',       platform: :mri
  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'dead_end',        require: false
end
