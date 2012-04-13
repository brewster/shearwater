module Shearwater

  module SpecSupport

    module MigrationTracker

      extend self

      Event = Struct.new(:id, :action)

      def migrated!(id)
        events << Event.new(id, :migrate)
      end

      def rolled_back!(id)
        events << Event.new(id, :rollback)
      end

      def has_migrated?(id)
        event?(id, :migrate)
      end

      def has_rolled_back?(id)
        event?(id, :rollback)
      end

      def clear!
        events.clear
      end

      def events
        @events ||= []
      end

      def event?(id, action)
        events.any? { |e| e.id == id && e.action == action }
      end

    end

  end

end
