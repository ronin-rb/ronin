# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './lib/ronin/version.rb'

Hoe.new('ronin', Ronin::VERSION) do |p|
  p.rubyforge_name = 'ronin'
  p.developer('Postmodern','postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs/ronin'
  p.extra_deps = [
    ['nokogiri', '>=1.2.0'],
    ['dm-core', '>=0.9.9'],
    ['data_objects', '>=0.9.9'],
    ['do_sqlite3', '>=0.9.9'],
    ['dm-types', '>=0.9.9'],
    ['dm-serializer', '>=0.9.9'],
    ['dm-aggregates', '>=0.9.9'],
    ['dm-validations', '>=0.9.9'],
    ['dm-predefined', '>=0.1.0'],
    ['parameters', '>=0.1.3'],
    ['contextify', '>=0.1.2'],
    ['reverse-require', '>=0.3.1'],
    ['repertoire', '>=0.1.2']
  ]
end

# vim: syntax=Ruby
