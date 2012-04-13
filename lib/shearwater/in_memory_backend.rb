require 'set'

module Shearwater
  class InMemoryBackend
    def initialize
      @migrations = SortedSet[]
    end

    def migrated!(id)
      @migrations << id
    end

    def rolled_back!(id)
      @migrations.delete(id)
    end

    def migrated?(id)
      @migrations.include?(id)
    end

    def last_migration
      @migrations.to_a.last
    end
  end
end
