module Jekyll
  class ServerPage < Page
    def initialize(site, base, dir, attributes)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.md'

      process(@name)
      read_yaml(File.join(base, '_layouts'), 'server.md')
      data['server'] = extract_details(attributes['automatic'])
      data['title'] = attributes['name']
    end

    private

    def extract_details(ohai)
      {
        'chassis' => extract_chassis(ohai),
        'cpus' => extract_cpus(ohai),
        'memory' => extract_memory(ohai),
        'interfaces' => extract_interfaces(ohai),
        'os' => ohai['lsb']['description']
      }
    end

    def extract_chassis(ohai)
      if system = ohai['dmi']['system']
        "#{system['manufacturer']} #{system['product_name']}"
      end
    end
    
    def extract_cpus(ohai)
      ohai['cpu']
        .select { |_, cpu| cpu.is_a?(Hash) && cpu['core_id'] == '0' }
        .map { |_, cpu| { :id => cpu['physical_id'], :model => cpu['model_name'].squeeze(' ').strip, :cores => cpu['cores'] } }
        .group_by { |cpu| cpu[:model] }
        .map { |model, cpus| { 'model' => model, 'cores' => cpus.first[:cores], 'count' => cpus.uniq.count } }
    end

    def extract_memory(ohai)
      if ohai['memory']['total'] =~ /^(\d+)kB/
        kblog2 = Math.log2($1.to_f).ceil
      end

      if kblog2 >= 20
        sprintf "%dGB", 2 ** (kblog2 - 20)
      elsif kblog2 >= 10
        sprintf "%dMB", 2 ** (kblog2 - 10)
      else
        sprintf "%dKB", 2 ** (kblog2 - 0)
      end
    end

    def extract_interfaces(ohai)
      ohai['network']['interfaces']
        .select { |_, interface| interface['encapsulation'] == 'Ethernet' }
        .map { |name, interface| { 'name' => name, 'addresses' => extract_addresses(interface) } }
        .sort_by { |interface| interface['name'] }
    end

    def extract_addresses(interface)
      interface['addresses']
        .reject { |address, properties| properties['scope'] == 'Link' }
        .map { |address, _| address }
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
