module Jekyll
  module RecentFilter
    def recent(nodes)
      # require activity in the last 30 days
      cutoff = Time.now - (30 * 24 * 60 * 60)

      nodes.select do |node|
        time = node['automatic']['ohai_time']
        time > cutoff.to_f
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::RecentFilter)
