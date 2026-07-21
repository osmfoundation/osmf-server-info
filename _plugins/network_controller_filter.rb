# frozen_string_literal: true

module Jekyll
  module NetworkControllerFilter
    def network_controller_index(nodes)
      site = @context.registers[:site]

      nodes
        .flat_map { |node| node_network_controllers(node, site) }
        .group_by { |controller| controller[:model] }
        .map { |model, entries| { "model" => model, "servers" => IndexServers.counted(entries) } }
        .sort_by { |controller| controller["model"] }
    end

    private

    def node_network_controllers(node, site)
      ohai = node["automatic"]

      return [] unless ohai && ohai["hardware"] && ohai["hardware"]["pci"]

      ohai["hardware"]["pci"]
        .select { |_, device| device["class_name"] == "Ethernet controller" }
        .select { |_, device| device["function"] == "0" }
        .map { |_, device| PciDevice.describe(device, site) }
        .tally
        .map { |model, count| { :server => node["name"], :model => model, :count => count } }
    end
  end
end

Liquid::Template.register_filter(Jekyll::NetworkControllerFilter)
