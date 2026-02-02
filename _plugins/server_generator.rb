# frozen_string_literal: true

module Jekyll
  class ServerPage < Page
    # rubocop:disable Lint/MissingSuper
    def initialize(site, base, dir, attributes)
      @site = site
      @base = base
      @dir = dir
      @name = "index.md"

      process(@name)
      read_yaml(File.join(base, "_layouts"), "server.md")
      data["server"] = extract_details(attributes["automatic"])
      data["title"] = attributes["name"]
      data["roles"] = attributes["automatic"]["roles"]
      data["thanks_to"] = ThanksTo.thanks_to(attributes, @site)
      data["additional_thanks"] = ThanksTo.additional_thanks(attributes, @site)
    end
    # rubocop:enable Lint/MissingSuper

    KB = 1024
    MB = KB * 1024
    GB = MB * 1024
    TB = GB * 1024

    private

    def extract_details(ohai)
      {
        "system" => extract_system(ohai),
        "cpus" => extract_cpus(ohai),
        "memory" => extract_memory(ohai),
        "disk" => extract_disk(ohai),
        "network" => extract_network(ohai),
        "power" => extract_power(ohai),
        "oob" => extract_oob(ohai),
        "bios" => extract_bios(ohai),
        "os" => extract_os(ohai),
        "roles" => extract_roles(ohai),
        "lvs" => extract_lvs(ohai),
        "filesystems" => extract_filesystems(ohai)
      }
    end

    def extract_system(ohai)
      System.details(ohai, @site)
    end

    def extract_cpus(ohai)
      if ohai["cpu"]
        ohai["cpu"]
          .select { |_, cpu| cpu.is_a?(Hash) && cpu.key?("physical_id") }
          .map { |_, cpu| extract_cpu(cpu) }
          .sort_by { |cpu| [cpu[:physical_id], cpu[:core_id]] }
          .uniq { |cpu| cpu[:physical_id] }
          .group_by { |cpu| cpu[:model] }
          .map { |model, cpus| { "model" => model, "cores" => cpus.first[:cores], "count" => cpus.count } }
      else
        []
      end
    end

    def extract_cpu(cpu)
      {
        :physical_id => cpu["physical_id"],
        :core_id => cpu["core_id"],
        :model => cpu["model_name"].squeeze(" ").strip,
        :cores => cpu["cores"]
      }
    end

    def extract_memory(ohai)
      {
        "total" => extract_memory_total(ohai),
        "devices" => extract_memory_devices(ohai)
      }
    end

    def extract_memory_total(ohai)
      if ohai["memory"] && ohai["memory"]["total"]
        format_size(parse_size(ohai["memory"]["total"]))
      else
        0
      end
    end

    def extract_memory_devices(ohai)
      if ohai["hardware"] && ohai["hardware"]["memory"]
        ohai["hardware"]["memory"]
          .reject { |device| device["type"] == "Flash" }
          .map { |device| { :size => parse_size(device["size"]), :type => describe_memory_device(device) } }
          .group_by { |device| device[:type] }
          .map { |type, devices| { "type" => type, "size" => devices.first[:size], "count" => devices.count } }
          .sort_by { |device| device["size"] }
          .reverse
      else
        []
      end
    end

    def describe_memory_device(device)
      form_factor = device["form_factor"]

      if device["size"] == "No Module Installed"
        "Spare #{form_factor} slot"
      else
        size = format_size(parse_size(device["size"]))
        type = device["type"]
        speed = device["speed"]

        form_factor = "" if type.end_with?(form_factor)

        if speed == "Unknown"
          "#{size} #{type} #{form_factor}".strip
        else
          "#{size} #{speed} #{type} #{form_factor}".strip
        end
      end
    end

    def extract_disk(ohai)
      {
        "controllers" => extract_disk_controllers(ohai),
        "arrays" => extract_disk_arrays(ohai),
        "disks" => extract_disk_disks(ohai)
      }
    end

    def extract_disk_controllers(ohai)
      if ohai["hardware"]
        ohai["hardware"]["pci"]
          .select { |_, device| disk_controller?(device) }
          .map { |_, device| device_name(device) }
          .sort
      else
        []
      end
    end

    def disk_controller?(device)
      ["SATA controller", "RAID bus controller", "SCSI storage controller", "Serial Attached SCSI controller",
       "Non-Volatile memory controller"].include?(device["class_name"])
    end

    def extract_disk_arrays(ohai)
      if ohai["hardware"] && ohai["hardware"]["disk"]
        ohai["hardware"]["disk"]["arrays"]
          .map { |array| array_details(array) }
          .sort_by { |array| array["device"] }
      else
        []
      end
    end

    def array_details(array)
      {
        "device" => array["device"],
        "size" => array["size"],
        "level" => array["raid_level"],
        "disks" => array["disks"].count
      }
    end

    def extract_disk_disks(ohai)
      if ohai["hardware"] && ohai["hardware"]["disk"]
        ohai["hardware"]["disk"]["disks"]
          .map { |device| { :size => device["size"], :type => describe_disk_device(device) } }
          .group_by { |device| device[:type] }
          .map { |type, devices| { "type" => type, "size" => devices.first[:size], "count" => devices.count } }
          .sort_by { |device| parse_size(device["size"]) }
          .reverse
      else
        []
      end
    end

    def describe_disk_device(device)
      vendor = device["vendor"]
      model = device["model"]

      vendor = @site.data["names"]["vendors"][vendor] || vendor

      "#{vendor} #{model}"
    end

    def extract_network(ohai)
      {
        "controllers" => extract_network_controllers(ohai),
        "interfaces" => extract_network_interfaces(ohai)
      }
    end

    def extract_network_controllers(ohai)
      if ohai["hardware"]
        ohai["hardware"]["pci"]
          .select { |_, device| device["class_name"] == "Ethernet controller" }
          .select { |_, device| device["function"] == "0" }
          .map { |_, device| device_name(device) }
          .sort
      else
        []
      end
    end

    def extract_network_interfaces(ohai)
      if ohai["network"] && ohai["network"]["interfaces"]
        ohai["network"]["interfaces"]
          .select { |_, interface| interface["encapsulation"] == "Ethernet" && interface["addresses"] }
          .map { |name, interface| extract_network_interface(ohai, name, interface) }
          .sort_by { |interface| interface["name"] }
      else
        []
      end
    end

    def extract_network_interface(ohai, name, interface)
      {
        "name" => name,
        "state" => interface_state(ohai, name, interface),
        "addresses" => extract_addresses(interface)
      }
    end

    def extract_addresses(interface)
      interface["addresses"]
        .reject { |_address, properties| properties["scope"] == "Link" }
        .map { |address, _| address }
    end

    def interface_state(ohai, name, interface)
      state = interface["state"][0].upcase + interface["state"][1..]

      if %w[Up Active Backup].include?(state)
        speed = case interface["link_speed"]
                when 0, nil then "Virtual"
                when 10 then "10Mb"
                when 100 then "100Mb"
                when 1000 then "1Gb"
                when 2000 then "2Gb"
                when 2500 then "2.5Gb"
                when 5000 then "5Gb"
                when 10_000 then "10Gb"
                when 20_000 then "20Gb"
                when 25_000 then "25Gb"
                when 50_000 then "50Gb"
                when 100_000 then "100Gb"
                when 200_000 then "200Gb"
                else interface["link_speed"]
                end

        duplex = if interface["duplex"] && interface["duplex"] != "Unknown! (255)"
                   "#{interface['duplex'].downcase} duplex"
                 end
      end

      if ohai["lldp"] && ohai["lldp"][name]
        if ohai["lldp"][name]["port"]["descr"]
          port = ohai["lldp"][name]["port"]["descr"]
        elsif ohai["lldp"][name]["port"]["id"]["type"] == "ifname"
          port = ohai["lldp"][name]["port"]["id"]["value"]
        end

        peer = "connected to #{port}" if port
      end

      [state, speed, duplex, peer].compact.join(", ")
    end

    def extract_power(ohai)
      {
        "psus" => extract_psus(ohai)
      }
    end

    def extract_psus(ohai)
      if ohai["hardware"] && ohai["hardware"]["psu"]
        ohai["hardware"]["psu"]
          .reject { |device| device["max_power_capacity"] == "Unknown" }
          .map { |device| { :capacity => parse_watts(device["max_power_capacity"]), :type => describe_psu(device) } }
          .group_by { |device| device[:type] }
          .map { |type, devices| { "type" => type, "capacity" => devices.first[:capacity], "count" => devices.count } }
      else
        []
      end
    end

    def describe_psu(device)
      vendor = device["manufacturer"]
      model = device["model_part_number"]

      vendor = @site.data["names"]["vendors"][vendor] || vendor

      "#{vendor} #{model}"
    end

    def extract_oob(ohai)
      return unless ohai["hardware"] && ohai["hardware"]["mc"] && !ohai["hardware"]["mc"].empty?

      if ohai["hardware"]["mc"]["manufacturer_name"] == "Unknown"
        case ohai["hardware"]["mc"]["manufacturer_id"]
        when "2" then vendor = "IBM"
        when "11", "47196" then vendor = "HP"
        when "4163" then vendor = "ASUS"
        when "47488" then vendor = "Supermicro"
        end
      else
        vendor = ohai["hardware"]["mc"]["manufacturer_name"]
      end

      product = ohai["hardware"]["mc"]["product_id"]

      vendor = @site.data["names"]["vendors"][vendor] || vendor

      if vendor == "HP"
        pci = ohai["hardware"]["pci"].select { |_slot, device| device["driver"] == "hpilo" }.values.first

        product = pci["subsystem_device_id"]
      end

      @site.data["names"]["oobs"]["#{vendor} #{product}"] || "OOB #{vendor} #{product}"
    end

    def extract_bios(ohai)
      if ohai["dmi"] && (bios = ohai["dmi"]["bios"])
        "#{bios['vendor']} version #{bios['version']}"
      end
    end

    def extract_os(ohai)
      return unless ohai["lsb"] && ohai["lsb"]["description"]

      ohai["lsb"]["description"]
    end

    def extract_roles(ohai)
      if ohai["roles"]
        ohai["roles"]
          .map { |role| { "name" => role, "description" => describe_role(role) } }
      else
        []
      end
    end

    def describe_role(name)
      role = @site.data["roles"]["rows"]
                  .find { |role| role["name"] == name }
      role ? role["description"] : ""
    end

    def extract_lvs(ohai)
      if ohai["hardware"] && ohai["hardware"]["lvm"]
        ohai["hardware"]["lvm"]["lvs"]
          .map { |name, details| { "name" => name, "description" => describe_lv(details, ohai) } }
          .sort_by { |lv| lv["name"] }
      else
        []
      end
    end

    def describe_lv(lv, ohai)
      size = format_size(lv["lv_size"].to_i / 2)
      pvs =  ohai["hardware"]["lvm"]["pvs"]
             .select { |_, pv| pv["vg"] == lv["vg"] }
             .map { |device, _| device }

      "#{size} on #{pvs.join(', ')}"
    end

    def extract_filesystems(ohai)
      if ohai["filesystem"] && ohai["filesystem"]["by_device"]
        ohai["filesystem"]["by_device"]
          .select { |device, _| device.start_with?("/") }
          .select { |_, details| details.include?("kb_size") }
          .map { |device, details| extract_filesystem(device, details) }
          .sort_by { |filesystem| filesystem["mountpoint"] || "xxx" }
      else
        []
      end
    end

    def extract_filesystem(device, details)
      {
        "mountpoint" => details["mounts"],
        "description" => describe_filesystem(device, details)
      }
    end

    def describe_filesystem(device, details)
      size = format_size(details["kb_size"].to_i)
      available = format_size(details["kb_available"].to_i)
      fstype = details["fs_type"]

      "#{size} #{fstype} on #{device} with #{available} free"
    end

    def device_name(device)
      if device["subsystem_device_name"] =~ /^Device \h{4}$/ ||
         device["subsystem_vendor_name"] != device["vendor_name"]
        vendor = device["vendor_name"]
        name = device["device_name"]
      else
        vendor = device["subsystem_vendor_name"]
        name = device["subsystem_device_name"]
      end

      vendor = @site.data["names"]["vendors"][vendor] || vendor

      "#{vendor} #{name}"
    end

    def parse_size(size)
      case size
      when /^([0-9.]+)\s*TB/i
        Regexp.last_match(1).to_i * 1024 * 1024 * 1024
      when /^([0-9.]+)\s*GB/i
        Regexp.last_match(1).to_i * 1024 * 1024
      when /^([0-9.]+)\s*MB/i
        Regexp.last_match(1).to_i * 1024
      when /^([0-9.]+)\s*KB/i
        Regexp.last_match(1).to_i
      else
        0
      end
    end

    def format_size(kb, granularity = MB)
      return "" if kb.zero?

      granularity /= 1024
      kb = (kb.to_f / granularity).round * granularity

      kblog2 = Math.log2(kb)

      if kblog2 >= 30
        format "%dTB", (2**(kblog2 - 30)).round
      elsif kblog2 >= 20
        format "%dGB", (2**(kblog2 - 20)).round
      elsif kblog2 >= 10
        format "%dMB", (2**(kblog2 - 10)).round
      else
        format "%dKB", (2**(kblog2 - 0)).round
      end
    end

    def parse_watts(power)
      if power =~ /^\s*(\d+)\s*W\s*$/i
        ::Regexp.last_match(1).to_i
      else
        0
      end
    end
  end

  class ServerPageGenerator < Generator
    safe true

    def generate(site)
      dir = "servers"
      site.data["nodes"]["rows"].each do |server|
        site.pages << ServerPage.new(site, site.source, File.join(dir, server["name"]), server)
      end
    end
  end
end
