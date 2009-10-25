require 'ronin/platform/extension'

ronin_extension do

  attr_reader :var
  attr_writer :var

  setup do
    @var = :setup
  end

  teardown do
    @var = :toredown
  end

  def test_method
    :method
  end

  def run_method
    @var = :running
  end

end
