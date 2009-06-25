require 'ronin/scanner'

class ExampleScanner

  include Ronin::Scanner

  scanner(:test1) do |results,target|
    results << 1
  end

  scanner(:test2) do |results,target|
    results << 2
  end

  scanner(:test2) do |results,target|
    results << 2
  end

end
