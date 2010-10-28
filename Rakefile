require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  STDERR.puts e.message
  STDERR.puts "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'ore/tasks'
Ore::Tasks.new

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
