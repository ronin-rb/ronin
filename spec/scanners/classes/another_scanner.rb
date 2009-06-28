require 'scanners/classes/example_scanner'

class AnotherScanner < ExampleScanner

  scanner(:test1) do |target,results|
    results.call(1)
  end

  scanner(:test3) do |target,results|
    results.call(3)
  end

  scanner(:fail) do |target,results|
  end

end
