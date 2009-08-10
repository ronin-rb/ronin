require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'History.txt']
  t.options = [
    '--protected',
    '--files', 'COPYING.txt',
    '--title', 'Ronin',
    '--quiet'
  ]
end
