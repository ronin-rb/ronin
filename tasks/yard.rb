require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'History.txt']
  t.options = ['--quiet', '--protected', '--title', 'Ronin']
end
