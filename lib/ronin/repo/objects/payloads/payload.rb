module Ronin
  module Payloads
    class Payload

      include Repo::ObjectContext

      object_contextify :payload

    end
  end
end

