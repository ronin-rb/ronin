require 'yard'

lib_dir = File.expand_path(File.join(File.dirname(__FILE__),'..','lib'))
unless $LOAD_PATH.include?(lib_dir)
  $LOAD_PATH << lib_dir
end

require 'contextify/yard/handlers'
require 'parameters/yard/handlers'
require 'ronin/yard/handlers'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = [
    '--protected',
    '--files', 'History.txt',
    '--title', 'Ronin'
  ]
end

task :docs => :yardoc
