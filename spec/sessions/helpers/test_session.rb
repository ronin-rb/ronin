require 'ronin/sessions/session'

module TestSession
  include Sessions::Session

  def connect
    require_variable :host

    return @host
  end
end
