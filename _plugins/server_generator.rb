module Jekyll
  class ServerPage < Page
    def initialize(site, base, dir, server)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.md'

      process(@name)
      read_yaml(File.join(base, '_layouts'), 'server.md')
      data['server'] = server
      data['title'] = server['name']
    end
  end

  class ServerPageGenerator < Generator
    safe true

    def generate(site)
      dir = 'servers'
      site.data['nodes']['rows'].each do |server|
        site.pages << ServerPage.new(site, site.source, File.join(dir, server['name']), server)
      end
    end
  end
end
