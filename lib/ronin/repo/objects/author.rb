module Ronin
  class Author

    include Repo::ObjectContext

    object_contextify :author

  end
end
