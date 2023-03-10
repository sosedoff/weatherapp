# A general purpose wrapper for caching functionality.

module Cache
  DEFAULT_TTL = 24.hours.to_i

  def self.query_cache(prefix, query, ttl: DEFAULT_TTL, &blk)
    key = Digest::SHA1.hexdigest(query.downcase)
    Rails.cache.fetch([prefix, key], expires_in: ttl, &blk)
  end

  def self.content_cache(prefix, key, ttl: DEFAULT_TTL, &blk)
    data = Rails.cache.fetch([prefix, key], expires_in: ttl, &blk)
  end

  def self.wrap(prefix, key, ttl: DEFAULT_TTL)
    exists = true
    data = Rails.cache.fetch([prefix, key], expires_in: ttl, skip_nil: true) do
      exists = false
      yield
    end
    [data, exists]
  end

  def self.read(prefix, key)
    Rails.cache.read([prefix, key])
  end

  def self.write(prefix, key, data, ttl: DEFAULT_TTL)
    Rails.cache.write([prefix, key], data, expires_in: ttl)
  end

  def self.delete(prefix, key)
    Rails.cache.delete([prefix, key])
  end
end
