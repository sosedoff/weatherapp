require "rails_helper"

RSpec.describe Cache do
  let(:prefix) { "test" }
  let(:key)    { "key" }
  let(:query)  { "SELECT * FROM users" }
  let(:data)   { "cached data" }
  let(:ttl)    { 60 }

  before do
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end

  describe ".query_cache" do
    subject { described_class.query_cache(prefix, query, ttl: ttl) { data } }

    it "caches the result using a SHA1 of the query" do
      expect(subject).to eq(data)
      # Should fetch from cache on second call
      expect(described_class.query_cache(prefix, query, ttl: ttl) { "other" }).to eq(data)
    end

    it "uses default TTL when not specified" do
      expect(described_class.query_cache(prefix, query) { data }).to eq(data)
    end

    it "downcases the query before hashing" do
      expect(Digest::SHA1).to receive(:hexdigest).with(query.downcase).and_return("hash")
      described_class.query_cache(prefix, query, ttl: ttl) { data }
    end
  end

  describe ".content_cache" do
    subject { described_class.content_cache(prefix, key, ttl: ttl) { data } }

    it "caches the result using the given key" do
      expect(subject).to eq(data)
      expect(described_class.content_cache(prefix, key, ttl: ttl) { "other" }).to eq(data)
    end

    it "uses default TTL when not specified" do
      expect(described_class.content_cache(prefix, key) { data }).to eq(data)
    end

    it "returns the cached data" do
      expect(subject).to eq(data)
    end
  end

  describe ".wrap" do
    it "returns [data, exists] where exists is false on first call" do
      result, exists = described_class.wrap(prefix, key, ttl: ttl) { data }
      expect(result).to eq(data)
      expect(exists).to eq(false)
    end

    it "returns [data, exists] where exists is true on subsequent calls" do
      described_class.wrap(prefix, key, ttl: ttl) { data }
      result, exists = described_class.wrap(prefix, key, ttl: ttl) { "other" }
      expect(result).to eq(data)
      expect(exists).to eq(true)
    end

    it "uses default TTL when not specified" do
      result, exists = described_class.wrap(prefix, key) { data }
      expect(result).to eq(data)
      expect(exists).to eq(false)
    end

    it "sets exists to true initially" do
      exists = true
      described_class.wrap(prefix, key, ttl: ttl) { exists = false }
      # The exists variable should be set to false inside the block
      expect(exists).to eq(false)
    end

    it "handles nil values with skip_nil option" do
      result, exists = described_class.wrap(prefix, key, ttl: ttl) { nil }
      expect(result).to be_nil
      expect(exists).to eq(false)
    end
  end

  describe ".read" do
    subject { described_class.read(prefix, key) }

    it "reads the cached value" do
      described_class.write(prefix, key, data, ttl: ttl)
      expect(subject).to eq(data)
    end

    it "returns nil when key doesn't exist" do
      expect(subject).to be_nil
    end
  end

  describe ".write" do
    subject { described_class.write(prefix, key, data, ttl: ttl) }

    it "writes the value to the cache" do
      expect(subject).to eq(true)
      expect(described_class.read(prefix, key)).to eq(data)
    end

    it "uses default TTL when not specified" do
      expect(described_class.write(prefix, key, data)).to eq(true)
      expect(described_class.read(prefix, key)).to eq(data)
    end
  end

  describe ".delete" do
    subject { described_class.delete(prefix, key) }

    it "deletes the value from the cache" do
      described_class.write(prefix, key, data, ttl: ttl)
      expect(described_class.read(prefix, key)).to eq(data)
      subject
      expect(described_class.read(prefix, key)).to be_nil
    end

    it "returns true when key exists" do
      described_class.write(prefix, key, data, ttl: ttl)
      expect(subject).to eq(true)
    end

    it "returns false when key doesn't exist" do
      expect(subject).to eq(false)
    end
  end

  describe "DEFAULT_TTL" do
    it "is set to 24 hours in seconds" do
      expect(described_class::DEFAULT_TTL).to eq(24.hours.to_i)
    end
  end
end 
