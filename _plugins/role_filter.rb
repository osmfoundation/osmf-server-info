# frozen_string_literal: true

module Jekyll
  module RoleFilter
    def role_index(nodes)
      nodes
        .flat_map { |node| node_roles(node) }
        .group_by { |role| role[:name] }
        .map { |name, entries| { "name" => name, "servers" => IndexServers.names(entries) } }
        .sort_by { |role| role["name"] }
    end

    private

    def node_roles(node)
      roles = (node["automatic"] && node["automatic"]["roles"]) || []
      node_name = node["name"].split(".").first

      roles
        .reject { |role| role == node_name }
        .map { |role| { :server => node["name"], :name => role } }
    end
  end
end

Liquid::Template.register_filter(Jekyll::RoleFilter)
