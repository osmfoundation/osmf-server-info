# frozen_string_literal: true

class PciDevice
  def self.describe(device, site)
    if device["subsystem_device_name"] =~ /^Device \h{4}$/ ||
       device["subsystem_vendor_name"] != device["vendor_name"]
      vendor = device["vendor_name"]
      name = device["device_name"]
    else
      vendor = device["subsystem_vendor_name"]
      name = device["subsystem_device_name"]
    end

    vendor = site.data["names"]["vendors"][vendor] || vendor

    "#{vendor} #{name}"
  end
end
