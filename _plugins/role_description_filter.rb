module Jekyll
  module RoleDescriptionFilter
    def role_description(roles, server_name)
      site = @context.registers[:site]

      roles.map do |name|
        next if name == server_name
        next if site.data['boring_roles'].include? name
        role = site.data['roles']['rows']
               .find { |role| role['name'] == name }
        role ? role['name'] : ''
      end.join(' ')
    end
  end
end

Liquid::Template.register_filter(Jekyll::RoleDescriptionFilter)
