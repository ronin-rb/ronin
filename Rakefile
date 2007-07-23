require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

require 'lib/version'

Gem::manage_gems

PACKAGE_VERSION = Ronin::RONIN_VERSION
CLEAN = ["pkg","html","rdoc"]
PACKAGE_FILES = FileList[
	'README',
	'ChangeLog',
	'Rakefile',
	'lib/**/*.rb',
	'bin/*'
].to_a
PROJECT = 'ronin'

ENV['RUBYFORGE_USER'] = "postmodern@rubyforge.org"
ENV['RUBYFORGE_PROJECT'] = "/var/www/gforge-projects/#{PROJECT}"

desc 'Release Files'
task :default => [:rdoc, :doc, :gem, :package]

rd = Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Ronin -- A decentralized security platform"
  rdoc.rdoc_files.include('README', 'ChangeLog')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '-N'
  rdoc.options << '-S'
end

gem_spec = Gem::Specification.new do |s|
  s.platform  =   Gem::Platform::RUBY
  s.name = PROJECT
  s.version = PACKAGE_VERSION
  s.author = "Postmodern Modulus III"
  s.email = "postmodern@users.sourceforge.net"
  s.summary = "A decentralized security platform designed to promote the distribution of information security tools and information"
  s.files = PACKAGE_FILES
  s.require_path = "lib"
  s.autorequire = "ronin"
  s.executables << 'ronin'

  s.has_rdoc = true
  s.rdoc_options << '--line-numbers' << '--inline-source' << '--main' << 'README'

  s.add_dependency('og')
  s.add_dependency('mechanize')
end

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.gem_spec = gem_spec
  pkg.need_tar = true
  pkg.need_zip = true
end

Rake::PackageTask.new('ronin',Ronin::RONIN_VERSION) do |pkg|
  pkg.need_zip = true
  pkg.package_files = FileList[
	  'RAKEFILE',
	  'ChangeLog',
	  'README',
	  'doc/**/*',
	  'examples/**/*',
	  'lib/**/*',
	  'test/**/*'
  ].to_a

  class << pkg
    def package_name
      "#{@name}-#{@version}-src"
    end
  end
end

desc "Publish RDOC to RubyForge"
task :rubyforge => [:rdoc, :gem] do
  Rake::SshDirPublisher.new(ENV['RUBYFORGE_USER'], ENV['RUBYFORGE_PROJECT'], 'html').upload
end
