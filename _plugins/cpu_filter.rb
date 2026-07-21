# frozen_string_literal: true

module Jekyll
  module CpuFilter
    def cpu_index(nodes)
      nodes
        .flat_map { |node| node_cpus(node) }
        .group_by { |cpu| [cpu[:model], cpu[:cores]] }
        .map { |key, entries| cpu_entry(key, entries) }
        .sort_by { |cpu| [cpu["model"], cpu["cores"].to_i] }
    end

    private

    def cpu_entry(key, entries)
      model, cores = key

      { "model" => model, "cores" => cores, "servers" => IndexServers.counted(entries) }
    end

    def node_cpus(node)
      ohai = node["automatic"]

      return [] unless ohai && ohai["cpu"]

      ohai["cpu"]
        .select { |_, cpu| cpu.is_a?(Hash) && cpu.key?("physical_id") }
        .map { |_, cpu| cpu_details(cpu) }
        .uniq { |cpu| cpu[:physical_id] }
        .group_by { |cpu| [cpu[:model], cpu[:cores]] }
        .map { |key, cpus| node_cpu(node, key, cpus.count) }
    end

    def node_cpu(node, key, count)
      model, cores = key

      { :server => node["name"], :model => model, :cores => cores, :count => count }
    end

    def cpu_details(cpu)
      {
        :physical_id => cpu["physical_id"],
        :model => cpu["model_name"].squeeze(" ").strip,
        :cores => cpu["cores"]
      }
    end
  end
end

Liquid::Template.register_filter(Jekyll::CpuFilter)
