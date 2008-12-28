# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './lib/ronin/version.rb'

Hoe.new('ronin', Ronin::VERSION) do |p|
  p.rubyforge_name = 'ronin'
  p.developer('Postmodern','postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs/ronin'
  p.extra_deps = ['hpricot',
                  'mechanize',
                  ['spidr', '>=0.1.3'],
                  ['dm-core', '>=0.9.3'],
                  ['data_objects', '>=0.9.9'],
                  ['do_sqlite3', '>=0.9.9'],
                  ['dm-types', '>=0.9.3'],
                  ['dm-serializer', '>=0.9.3'],
                  ['dm-aggregates', '>=0.9.3'],
                  ['dm-validations', '>=0.9.3'],
                  ['dm-predefined', '>=0.1.0'],
                  ['parameters', '>=0.1.1'],
                  ['contextify', '>=0.1.0'],
                  ['reverse-require', '>=0.2.0'],
                  ['repertoire', '>=0.1.2']]
end

# vim: syntax=Ruby
