require 'classes/example_scanner'

class AnotherScanner < ExampleScanner

  scanner(:test1) do |results,target|
    results << 1
  end

  scanner(:test3) do |results,target|
    results << 3
  end

end
