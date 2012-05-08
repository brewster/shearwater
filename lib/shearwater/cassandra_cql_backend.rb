module Shearwater

  class CassandraCqlBackend

    def initialize(connection, column_family = 'schema_migrations')
      @connection, @column_family = connection, column_family
    end

    def migrated!(id)
      execute(
        "INSERT INTO #{@column_family} (version, migrated_at) VALUES (?, ?)",
        id, Time.now
      )
    end

    def rolled_back!(id)
      execute("DELETE FROM #{@column_family} WHERE version = ?", id)
    end

    def migrated?(id)
      !!execute(
        "SELECT migrated_at FROM #{@column_family} WHERE version = ?", id
      ).fetch_row.to_hash['migrated_at']
    end

    def last_migration
      row = execute(
        "SELECT version, migrated_at FROM #{@column_family}"
      ).map { |row| row.to_hash }.
        sort { |row2, row1| row1['migrated_at'] <=> row1['migrated_at'] }.first
      row['version'] if row
    end

    private

    def execute(*args)
      @connection.execute(*args)
    end

  end

end

