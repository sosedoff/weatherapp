#!/usr/bin/env ruby

# Test script to reproduce the geocoding error
require_relative 'config/environment'

puts "Testing geocoding with Default provider..."

# Test the default provider lookup
puts "Testing lookup for 'chicago'..."
begin
  entry = Geocoding.provider.lookup('chicago')
  
  if entry
    puts "✓ Default provider returned an entry"
    puts "  ID: #{entry.id}"
    puts "  City: #{entry.city}"
    puts "  State: #{entry.state}"
    puts "  Country: #{entry.country}"
    puts "  Valid: #{entry.valid?}"
  else
    puts "✗ Default provider returned nil"
  end
rescue => e
  puts "✗ Error occurred: #{e.class}: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.first(5)
end

puts "\nTesting direct Geocoder.search..."
begin
  result = Geocoder.search('chicago', params: { countrycodes: "us" })
  puts "✓ Geocoder.search returned #{result.length} results"
  
  if result.first
    puts "  First result data: #{result.first.data.inspect}"
  end
rescue => e
  puts "✗ Geocoder.search error: #{e.class}: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.first(5)
end

puts "\nTest completed!" 
