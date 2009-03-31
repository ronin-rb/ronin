require 'ronin/sessions/session'

module TestSession
  include Sessions::Session

  setup_session do
    parameter :var, :default => :stuff, :description => 'Test parameter'
  end

  def test_one
    'this_is_a_test'
  end
end
