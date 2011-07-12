require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'ore/tasks'
Ore::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

require 'dm-visualizer/rake/graphviz_task'
DataMapper::Visualizer::Rake::GraphVizTask.new(
  :include => %w[lib],
  :require => %w[
    ronin/arch
    ronin/address
    ronin/author
    ronin/campaign
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
    ronin/script/path
    ronin/repository
    ronin/port
    ronin/service
    ronin/service_credential
    ronin/web_credential
    ronin/software
    ronin/vendor
    ronin/target
    ronin/tcp_port
    ronin/udp_port
    ronin/url_scheme
    ronin/url_query_param_name
    ronin/url_query_param
    ronin/url
    ronin/user_name
    ronin/password
  ]
)

require 'yard'
YARD::Rake::YardocTask.new
