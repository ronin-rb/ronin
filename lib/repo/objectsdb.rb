require 'repo/cache'

module Ronin
  module Repo
    RONIN_OBJECTS_DB_PATH = File.join(RONIN_HOME_PATH,'objects')

    def ronin_objects
      $ronin_objects_db
    end

    protected

    $ronin_objects_db ||= Og.setup(:destroy => false, :evolve_schema => true, :store => :sqlite, :name => RONIN_OBJECTS_DB_PATH)

  end
end
