# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './lib/ronin/version.rb'

Hoe.spec('ronin') do |p|
  p.rubyforge_name = 'ronin'
  p.developer('Postmodern','postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs/ronin'
  p.extra_deps = [
    'hoe',
    ['nokogiri', '>=1.2.0'],
    ['extlib', '>=0.9.13'],
    ['dm-core', '>=0.10.0'],
    ['data_objects', '>=0.9.13'],
    ['do_sqlite3', '>=0.9.13'],
    ['dm-types', '>=0.10.0'],
    ['dm-serializer', '>=0.10.0'],
    ['dm-validations', '>=0.10.0'],
    ['dm-predefined', '>=0.1.2'],
    ['chars', '>=0.1.1'],
    ['parameters', '>=0.1.7'],
    ['contextify', '>=0.1.2'],
    ['reverse-require', '>=0.3.1'],
    ['repertoire', '>=0.2.1']
  ]
end

# vim: syntax=Ruby
