# frozen_string_literal: true

module Jekyll
  module SystemFilter
    def system_name(node)
      details = System.details(node["automatic"], @context.registers[:site])

      details["name"]
    end

    def system_motherboard(node)
      details = System.details(node["automatic"], @context.registers[:site])

      details["motherboard"]
    end
  end
end

Liquid::Template.register_filter(Jekyll::SystemFilter)
