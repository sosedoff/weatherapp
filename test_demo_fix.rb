#!/usr/bin/env ruby

# Test script to verify the demo provider fix
require_relative 'config/environment'

puts "Testing demo provider fix..."

# Set the provider to demo
Geocoding.provider = :demo

# Test the demo provider lookup
puts "Testing lookup for 'chicago'..."
entry = Geocoding.provider.lookup('chicago')

if entry
  puts "✓ Demo provider returned an entry"
  puts "  ID: #{entry.id}"
  puts "  City: #{entry.city}"
  puts "  State: #{entry.state}"
  puts "  Country: #{entry.country}"
  puts "  Valid: #{entry.valid?}"
  
  # Test the importer
  puts "\nTesting importer..."
  begin
    location = LocationService.import(entry)
    puts "✓ Importer succeeded!"
    puts "  Location ID: #{location.id}"
    puts "  External ID: #{location.external_id}"
    puts "  City: #{location.city}"
  rescue => e
    puts "✗ Importer failed: #{e.message}"
  end
else
  puts "✗ Demo provider returned nil"
end

puts "\nTest completed!" 
