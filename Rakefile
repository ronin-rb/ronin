# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/yard.rb'

Hoe.spec('ronin') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.readme_file = 'README.rdoc'
  self.history_file = 'History.rdoc'
  self.remote_rdoc_dir = 'docs/ronin'

  self.extra_deps = [
    ['yard', '>=0.5.2'],
    ['nokogiri', '>=1.3.3'],
    ['extlib', '>=0.9.14'],
    ['data_objects', '>=0.10.1'],
    ['do_sqlite3', '>=0.10.1'],
    ['dm-core', '>=0.10.2'],
    ['dm-types', '>=0.10.2'],
    ['dm-validations', '>=0.10.2'],
    ['dm-predefined', '>=0.2.0'],
    ['chars', '>=0.1.2'],
    ['parameters', '>=0.1.8'],
    ['contextify', '>=0.1.4'],
    ['repertoire', '>=0.2.3'],
    ['thor', '>=0.11.5']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.1.12']
  ]

  self.spec_extras = {:has_rdoc => 'yard'}
end

# vim: syntax=Ruby
