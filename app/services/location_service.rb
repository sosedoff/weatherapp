module LocationService
  # Sync current fetches the current weather for location and caches it
  def self.sync_current(location)
    Locations::Syncer.new(location).sync
  end

  # Sync extended forecast for the current location
  def self.sync_extended(location)
    Locations::ExtendedSyncer.new(location).sync
  end

  # Import creates a new Location records based on the geocoding entry
  def self.import(geocode_entry)
    Locations::Importer.new(geocode_entry).import
  end
end
