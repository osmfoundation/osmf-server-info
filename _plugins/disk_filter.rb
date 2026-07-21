# frozen_string_literal: true

module Jekyll
  module DiskFilter
    def disk_index(nodes)
      site = @context.registers[:site]

      nodes
        .flat_map { |node| node_disks(node, site) }
        .group_by { |disk| [disk[:model], disk[:size]] }
        .map { |key, entries| disk_entry(key, entries) }
        .sort_by { |disk| [disk["model"], parse_disk_size(disk["size"])] }
    end

    private

    def disk_entry(key, entries)
      model, size = key

      { "model" => model, "size" => size, "servers" => IndexServers.counted(entries) }
    end

    def node_disks(node, site)
      ohai = node["automatic"]

      return [] unless ohai && ohai["hardware"] && ohai["hardware"]["disk"]

      ohai["hardware"]["disk"]["disks"]
        .map { |device| { :model => describe_disk(device, site), :size => device["size"] } }
        .tally
        .map { |disk, count| node_disk(node, disk, count) }
    end

    def node_disk(node, disk, count)
      { :server => node["name"], :model => disk[:model], :size => disk[:size], :count => count }
    end

    def describe_disk(device, site)
      vendor = device["vendor"]
      model = device["model"]

      vendor = site.data["names"]["vendors"][vendor] || vendor

      "#{vendor} #{model}"
    end

    def parse_disk_size(size)
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
  end
end

Liquid::Template.register_filter(Jekyll::DiskFilter)
