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
    ['extlib', '>=0.9.12'],
    ['dm-core', '>=0.9.11'],
    ['data_objects', '>=0.9.11'],
    ['do_sqlite3', '>=0.9.11'],
    ['dm-types', '>=0.9.11'],
    ['dm-serializer', '>=0.9.11'],
    ['dm-validations', '>=0.9.11'],
    ['dm-predefined', '>=0.1.0'],
    ['chars', '>=0.1.1'],
    ['parameters', '>=0.1.5'],
    ['contextify', '>=0.1.2'],
    ['reverse-require', '>=0.3.1'],
    ['repertoire', '>=0.2.1']
  ]
end

# vim: syntax=Ruby
