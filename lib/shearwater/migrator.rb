module Shearwater

  class Migrator

    def initialize(migrations_dir, backend)
      @migrations_dir, @backend = migrations_dir, backend
    end

    def migrate
      migrations.keys.sort.each do |id|
        unless @backend.migrated?(id)
          migration = migrations[id]
          migration.up
          @backend.migrated!(id)
        end
      end
    end

    def rollback(step = 1)
      step.times do
        id = @backend.last_migration
        migration = migrations[id]
        migration.down
        @backend.rolled_back!(id)
      end
    end

    private

    def migrations
      @migrations ||= {}.tap do |migrations|
        Dir.glob(File.join(@migrations_dir, '**', '*.rb')).each do |file|
          if /(\d+)_(\w+)\.rb/ =~ file
            id, name = $1.to_i, $2
            load file
            class_name = name.split('_').map { |s| s.capitalize }.join
            migration = ::Object.const_get(class_name).new
            migrations[id] = migration
          end
        end
      end
    end

  end

end
