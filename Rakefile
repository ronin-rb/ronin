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
  gem.email = 'ronin-ruby@googlegroups.com'
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
  :bundle => [:default],
  :include => %w[lib],
  :require => %w[
    ronin/arch
    ronin/address
    ronin/author
    ronin/campaign
    ronin/comment
    ronin/country
    ronin/credential
    ronin/email_address
    ronin/host_name_ip_address
    ronin/host_name
    ronin/ip_address_mac_address
    ronin/ip_address
    ronin/license
    ronin/mac_address
    ronin/open_port
    ronin/organization
    ronin/os_guess
    ronin/os
    ronin/platform/cached_file
    ronin/platform/maintainer
    ronin/platform/overlay
    ronin/port
    ronin/service
    ronin/service_credential
    ronin/web_credential
    ronin/software
    ronin/target
    ronin/tcp_port
    ronin/udp_port
    ronin/url
    ronin/url_scheme
    ronin/user_name
    ronin/vendor
  ]
)

require 'yard'
YARD::Rake::YardocTask.new
