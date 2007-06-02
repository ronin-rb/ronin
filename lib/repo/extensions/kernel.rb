module Kernel

  protected

  def ronin_contexts
    $ronin_context_block ||= Hash.new { |hash,key| hash[key] = [] }
  end

end
