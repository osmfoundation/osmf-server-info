# frozen_string_literal: true

module Jekyll
  module PsuFilter
    def psu_index(nodes)
      site = @context.registers[:site]

      nodes
        .flat_map { |node| node_psus(node, site) }
        .group_by { |psu| [psu[:model], psu[:capacity]] }
        .map { |key, entries| psu_entry(key, entries) }
        .sort_by { |psu| [psu["model"], psu["capacity"]] }
    end

    private

    def psu_entry(key, entries)
      model, capacity = key

      { "model" => model, "capacity" => capacity, "servers" => IndexServers.counted(entries) }
    end

    def node_psus(node, site)
      ohai = node["automatic"]

      return [] unless ohai && ohai["hardware"] && ohai["hardware"]["psu"]

      ohai["hardware"]["psu"]
        .reject { |device| device["max_power_capacity"] == "Unknown" }
        .map { |device| psu_details(device, site) }
        .group_by { |device| [device[:model], device[:capacity]] }
        .map { |(model, capacity), devices| node_psu(node, model, capacity, devices.count) }
    end

    def psu_details(device, site)
      {
        :capacity => parse_psu_watts(device["max_power_capacity"]),
        :model => describe_psu(device, site)
      }
    end

    def node_psu(node, model, capacity, count)
      { :server => node["name"], :model => model, :capacity => capacity, :count => count }
    end

    def describe_psu(device, site)
      vendor = device["manufacturer"]
      model = device["model_part_number"]

      vendor = site.data["names"]["vendors"][vendor] || vendor

      site.data["names"]["psus"]["#{vendor} #{model}"] || "#{vendor} #{model}"
    end

    def parse_psu_watts(power)
      if power =~ /^\s*(\d+)\s*W\s*$/i
        ::Regexp.last_match(1).to_i
      else
        0
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::PsuFilter)
