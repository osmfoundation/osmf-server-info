# frozen_string_literal: true

module Jekyll
  module SystemIndexFilter
    def system_index(nodes)
      system_details_index(nodes, "name")
    end

    def motherboard_index(nodes)
      system_details_index(nodes, "motherboard")
    end

    private

    def system_details_index(nodes, field)
      site = @context.registers[:site]

      nodes
        .filter_map { |node| node_system_detail(node, field, site) }
        .group_by { |detail| detail[:model] }
        .map { |model, entries| { "model" => model, "servers" => IndexServers.names(entries) } }
        .sort_by { |detail| detail["model"] }
    end

    def node_system_detail(node, field, site)
      return unless node["automatic"]

      model = System.details(node["automatic"], site)[field]

      { :server => node["name"], :model => model } if model
    end
  end
end

Liquid::Template.register_filter(Jekyll::SystemIndexFilter)
