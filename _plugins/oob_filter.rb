# frozen_string_literal: true

module Jekyll
  module OobFilter
    def oob_index(nodes)
      site = @context.registers[:site]

      nodes
        .filter_map { |node| node_oob(node, site) }
        .group_by { |oob| oob[:model] }
        .map { |model, entries| { "model" => model, "servers" => IndexServers.names(entries) } }
        .sort_by { |oob| oob["model"] }
    end

    private

    def node_oob(node, site)
      ohai = node["automatic"]

      return unless ohai && ohai["hardware"] && ohai["hardware"]["mc"] && !ohai["hardware"]["mc"].empty?

      { :server => node["name"], :model => describe_oob(ohai, site) }
    end

    def describe_oob(ohai, site)
      mc = ohai["hardware"]["mc"]

      if mc["manufacturer_name"] == "Unknown"
        case mc["manufacturer_id"]
        when "2" then vendor = "IBM"
        when "11", "47196" then vendor = "HP"
        when "4163" then vendor = "ASUS"
        when "47488" then vendor = "Supermicro"
        end
      else
        vendor = mc["manufacturer_name"]
      end

      product = mc["product_id"]

      vendor = site.data["names"]["vendors"][vendor] || vendor

      if vendor == "HP"
        pci = ohai["hardware"]["pci"].select { |_slot, device| device["driver"] == "hpilo" }.values.first

        product = pci["subsystem_device_id"]
      end

      site.data["names"]["oobs"]["#{vendor} #{product}"] || "OOB #{vendor} #{product}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::OobFilter)
