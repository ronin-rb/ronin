module Ronin
  module Asm
    def asm(&block)
      new_block = Block.new
      new_block.asm(&block)
      return new_block;
    end
  end
end
