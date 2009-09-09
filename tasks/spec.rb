require 'hoe'
require 'spec/rake/spectask'

Hoe.plugins.delete(:test)

desc "Run all specifications"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs += ['lib', 'spec']
  t.spec_opts = ['--colour', '--format', 'specdoc']
end

task :default => :spec
