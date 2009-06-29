# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './lib/ronin/version.rb'

Hoe.spec('ronin') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern','postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = 'docs/ronin'
  self.extra_deps = [
    ['hoe', '>=2.0.0'],
    ['nokogiri', '>=1.2.0'],
    ['extlib', '>=0.9.13'],
    ['data_objects', '>=0.9.12'],
    ['do_sqlite3', '>=0.9.12'],
    ['dm-core', '>=0.9.11'],
    ['dm-types', '>=0.9.11'],
    ['dm-validations', '>=0.9.11'],
    ['dm-predefined', '>=0.1.1'],
    ['chars', '>=0.1.1'],
    ['parameters', '>=0.1.7'],
    ['contextify', '>=0.1.2'],
    ['reverse-require', '>=0.3.1'],
    ['repertoire', '>=0.2.1']
  ]
end

# vim: syntax=Ruby
