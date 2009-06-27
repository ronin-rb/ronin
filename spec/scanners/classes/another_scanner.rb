require 'scanners/classes/example_scanner'

class AnotherScanner < ExampleScanner

  scanner(:test1) do |target,results|
    results << 1
  end

  scanner(:test3) do |target,results|
    results << 3
  end

end
