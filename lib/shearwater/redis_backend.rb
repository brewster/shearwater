module Shearwater

  class RedisBackend

    def initialize(redis, key)
      @redis, @key = redis, key
    end

    def migrated!(id)
      @redis.zadd(@key, id, id.to_s)
    end

    def rolled_back!(id)
      @redis.zrem(@key, id.to_s)
    end

    def migrated?(id)
      @redis.zcount(@key, id, id) > 0
    end

    def last_migration
      @redis.zrange(@key, -1, -1).first
    end

  end

end
