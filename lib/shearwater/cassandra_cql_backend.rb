module Shearwater

  class CassandraCqlBackend

    def initialize(connection, column_family = 'schema_migrations')
      @connection, @column_family = connection, column_family
    end

    def migrated!(id)
      execute(
        "INSERT INTO #{@column_family} (version, migrated_at) VALUES (?, ?)",
        id.to_i, Time.now
      )
    end

    def rolled_back!(id)
      execute("DELETE FROM #{@column_family} WHERE version = ?", id.to_i)
    end

    def migrated?(id)
      !!execute(
        "SELECT migrated_at FROM #{@column_family} WHERE version = ?", id.to_i
      ).fetch_row.to_hash['migrated_at']
    end

    def last_migration
      rows = []
      execute(
        "SELECT version, migrated_at FROM #{@column_family}"
      ).fetch { |row| rows << row.to_hash }
      row = rows.reject { |row| row['migrated_at'].nil? }.sort { |row1, row2| row1['version'].to_i <=> row2['version'].to_i }.last
      row['version'].to_i if row
    end

    private

    def execute(*args)
      @connection.execute(*args)
    end

  end

end

