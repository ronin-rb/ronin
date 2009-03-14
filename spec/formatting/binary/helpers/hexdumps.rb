def load_binary_data(name)
  path = File.join(File.dirname(__FILE__),'hexdumps',"#{name}.bin")
  buffer = []

  File.open(path) do |file|
    file.each_byte { |b| buffer << b }
  end

  return buffer
end

def load_hexdump(name)
  File.read(File.join(File.dirname(__FILE__),'hexdumps',"#{name}.txt"))
end
