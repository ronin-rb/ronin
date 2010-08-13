require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/ronin/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'ronin'
  gem.version = Ronin::VERSION
  gem.licenses = ['GPL-2']
  gem.summary = %Q{A Ruby platform for exploit development and security research.}
  gem.description = %Q{Ronin is a Ruby platform for exploit development and security research. Ronin allows for the rapid development and distribution of code, exploits or payloads over many common Source-Code-Management (SCM) systems.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/ronin-ruby/ronin'
  gem.authors = ['Postmodern']
  gem.add_development_dependency 'bundler', '~> 0.9.23'
  gem.has_rdoc = 'yard'

  gem.post_install_message = %{
  Thank you for installing Ronin, a Ruby platform for exploit development
  and security research. To list the available commands:

    $ ronin help

  To jump into the Ronin Ruby Console:

    $ ronin

  Additional functionality can be added to Ronin by installing additional
  libraries:
  * ronin-asm
  * ronin-dorks
  * ronin-exploits
  * ronin-gen
  * ronin-int
  * ronin-php
  * ronin-scanners
  * ronin-sql
  * ronin-web
  }
end
Jeweler::GemcutterTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

require 'dm-visualizer/rake/graphviz_task'
DataMapper::Visualizer::Rake::GraphVizTask.new(
  :bundle => [:runtime],
  :include => ['lib'],
  :require => ['ronin/database', 'ronin/platform']
)

require 'yard'
YARD::Rake::YardocTask.new
