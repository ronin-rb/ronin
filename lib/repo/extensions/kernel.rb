module Kernel

  protected

  def ronin_contexts
    $ronin_context_block ||= {}
  end

end
