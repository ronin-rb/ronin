# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin Documentation'
  self.yard_options += ['--protected']
  self.remote_yard_dir = 'docs/ronin'

  self.extra_deps += [
    ['nokogiri', '>=1.3.3'],
    ['extlib', '>=0.9.14'],
    ['data_objects', '>=0.10.1'],
    ['do_sqlite3', '>=0.10.1'],
    ['dm-core', '>=0.10.2'],
    ['dm-types', '>=0.10.2'],
    ['dm-validations', '>=0.10.2'],
    ['dm-predefined', '>=0.2.1'],
    ['static_paths', '>=0.1.0'],
    ['chars', '>=0.1.2'],
    ['parameters', '>=0.1.8'],
    ['contextify', '>=0.1.4'],
    ['repertoire', '>=0.2.3'],
    ['thor', '>=0.11.5']
  ]

  self.extra_dev_deps += [
    ['rspec', '>=1.2.9'],
    ['yard', '>=0.5.3'],
    ['yard-dm', '>=0.1.0']
  ]
end

# vim: syntax=Ruby
