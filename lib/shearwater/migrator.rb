module Shearwater

  class Migrator

    def initialize(migrations_dir, backend, options = {})
      @migrations_dir, @backend = migrations_dir, backend
      @verbose = !!options[:verbose]
    end

    def migrate
      migrations.keys.sort.each do |id|
        unless @backend.migrated?(id)
          migration = migrations[id]
          say "Migrating #{migration.class.name}"
          migration.up
          @backend.migrated!(id)
        end
      end
    end

    def rollback(step = 1)
      step.times do
        id = @backend.last_migration
        break if id.nil?
        migration = migrations[id]
        say "Rolling back #{migration.class.name}"
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

    private

    def say(message)
      puts message if @verbose
    end

  end

end
