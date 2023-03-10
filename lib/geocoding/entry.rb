# Geocoding entry is a base class to hold the common geocoding attributes returned
# by the geocoding services.
#
module Geocoding
  class Entry
    include ActiveModel::AttributeAssignment

    attr_accessor :id,
                  :display_name,
                  :city,
                  :state,
                  :country,
                  :zipcode,
                  :lat,
                  :lon

    def initialize(attrs = {})
      self.assign_attributes(attrs)
    end

    def lat_lon
      [lat,lon]
    end

    def valid?
      id && city && state && country && lat && lon
    end
  end
end
