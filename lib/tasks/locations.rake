namespace :locations do
  desc "Sync all locations with current and extended forecast data"
  task sync_all: :environment do
    puts "Starting sync for all locations..."
    
    total_locations = Location.count
    synced_count = 0
    
    Location.find_each(batch_size: 100) do |location|
      puts "Syncing #{location.display_name}..."
      
      # Schedule both current and extended forecast jobs
      location.schedule_sync
      synced_count += 1
    end
    
    puts "Scheduled sync for #{synced_count} out of #{total_locations} locations"
    puts "Jobs are queued and will be processed by Sidekiq workers"
  end

  desc "Sync only stale locations (those not updated in last 5 minutes)"
  task sync_stale: :environment do
    puts "Starting sync for stale locations..."
    
    stale_locations = Location.stale
    total_stale = stale_locations.count
    
    if total_stale == 0
      puts "No stale locations found. All locations are up to date."
      return
    end
    
    synced_count = 0
    stale_locations.find_each(batch_size: 100) do |location|
      puts "Syncing stale location: #{location.display_name} (last sync: #{location.last_sync_at})"
      location.schedule_sync
      synced_count += 1
    end
    
    puts "Scheduled sync for #{synced_count} stale locations"
    puts "Jobs are queued and will be processed by Sidekiq workers"
  end

  desc "Force sync all locations (ignores stale threshold)"
  task force_sync_all: :environment do
    puts "Force syncing all locations (ignoring stale threshold)..."
    
    total_locations = Location.count
    synced_count = 0
    
    Location.find_each(batch_size: 100) do |location|
      puts "Force syncing #{location.display_name}..."
      
      # Run sync jobs immediately instead of queuing them
      Locations::CurrentForecastJob.perform_now(location.id)
      Locations::ExtendedForecastJob.perform_now(location.id)
      synced_count += 1
    end
    
    puts "Completed force sync for #{synced_count} locations"
  end

  desc "Show sync status for all locations"
  task status: :environment do
    puts "Location Sync Status:"
    puts "=" * 50
    
    Location.includes(:weather_point).find_each do |location|
      status = location.should_sync? ? "STALE" : "FRESH"
      last_sync = location.last_sync_at ? location.last_sync_at.strftime("%Y-%m-%d %H:%M:%S") : "NEVER"
      weather_point = location.weather_point ? "YES" : "NO"
      
      puts "#{location.display_name.ljust(20)} | #{status.ljust(6)} | Last: #{last_sync} | Weather Point: #{weather_point}"
    end
    
    stale_count = Location.stale.count
    total_count = Location.count
    
    puts "=" * 50
    puts "Summary: #{stale_count} stale out of #{total_count} total locations"
  end
end 
