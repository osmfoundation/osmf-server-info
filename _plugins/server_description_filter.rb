# frozen_string_literal: true

module Jekyll
  module ServerDescriptionFilter
    def server_description(roles)
      descriptions = @context.registers[:site].data["descriptions"]
      Array(roles).filter_map { |role| descriptions[role] }.join("<br>")
    end
  end
end

Liquid::Template.register_filter(Jekyll::ServerDescriptionFilter)
