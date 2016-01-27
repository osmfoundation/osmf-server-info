module Jekyll
  module ServerDescriptionFilter
    def server_description(roles)
      descriptions = @context.registers[:site].data['descriptions']
      roles.map { |role| descriptions[role] }.compact.join('<br>')
    end
  end
end

Liquid::Template.register_filter(Jekyll::ServerDescriptionFilter)
