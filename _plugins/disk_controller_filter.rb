# frozen_string_literal: true

module Jekyll
  module DiskControllerFilter
    DISK_CONTROLLER_CLASSES = [
      "SATA controller", "RAID bus controller", "SCSI storage controller",
      "Serial Attached SCSI controller", "Non-Volatile memory controller"
    ].freeze

    def disk_controller_index(nodes)
      site = @context.registers[:site]

      nodes
        .flat_map { |node| node_disk_controllers(node, site) }
        .group_by { |controller| controller[:model] }
        .map { |model, entries| { "model" => model, "servers" => IndexServers.counted(entries) } }
        .sort_by { |controller| controller["model"] }
    end

    private

    def node_disk_controllers(node, site)
      ohai = node["automatic"]

      return [] unless ohai && ohai["hardware"] && ohai["hardware"]["pci"]

      ohai["hardware"]["pci"]
        .select { |_, device| DISK_CONTROLLER_CLASSES.include?(device["class_name"]) }
        .map { |_, device| PciDevice.describe(device, site) }
        .tally
        .map { |model, count| { :server => node["name"], :model => model, :count => count } }
    end
  end
end

Liquid::Template.register_filter(Jekyll::DiskControllerFilter)
