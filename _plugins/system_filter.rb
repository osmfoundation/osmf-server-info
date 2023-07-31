class System
  def self.details(ohai, site)
    system = {}

    if ohai['virtualization'] &&
       ohai['virtualization']['role'] == 'guest'
      case ohai['virtualization']['system']
      when "openstack" then system['name'] = "OpenStack Virtual Machine"
      when "kvm" then system['name'] = "KVM Virtual Machine"
      when "vmware" then system['name'] = "VMWare Virtual Machine"
      when "xen" then system['name'] = "Xen Virtual Machine"
      else system['name'] = "Virtual Machine"
      end
    else
      if ohai['dmi'] &&
         ohai['dmi']['system'] &&
         ohai['dmi']['system']['manufacturer'] != 'empty' &&
         ohai['dmi']['system']['manufacturer'] != 'System manufacturer'
        system_manufacturer = ohai['dmi']['system']['manufacturer'].squeeze(' ').strip
        system_product = ohai['dmi']['system']['product_name'].squeeze(' ').strip
        system_sku = ohai['dmi']['system']['sku_number'].squeeze(' ').strip
      end

      if ohai['dmi'] &&
         ohai['dmi']['base_board'] &&
         ohai['dmi']['base_board']['product_name']
        base_board_manufacturer = ohai['dmi']['base_board']['manufacturer'].squeeze(' ').strip
        base_board_product = ohai['dmi']['base_board']['product_name'].squeeze(' ').strip
      end

      if system_manufacturer == base_board_manufacturer &&
         system_product == base_board_product
        if system_manufacturer == 'HP' || system_manufacturer == 'HPE'
          base_board_manufacturer = nil
          base_board_product = nil
        else
          system_manufacturer = nil
          system_product = nil
        end
      end

      if system_manufacturer == 'IBM'
        system_product.sub!(/\s*-\[([0-9]{4})([A-Z]{3})\]-$/, ' \1-\2')
      end

      system_manufacturer = site.data['names']['vendors'][system_manufacturer] || system_manufacturer
      base_board_manufacturer = site.data['names']['vendors'][base_board_manufacturer] || base_board_manufacturer

      if system_manufacturer && system_product
        if system_product.start_with?(system_manufacturer)
          system['name'] = "#{system_product}"
        else
          system['name'] = "#{system_manufacturer} #{system_product}"
        end
      end

      if base_board_manufacturer && base_board_product
        system['motherboard'] = "#{base_board_manufacturer} #{base_board_product}"
      end
    end

    system
  end
end

module Jekyll
  module SystemFilter
    def system_name(node)
      details = System::details(node['automatic'], @context.registers[:site])
      
      details['name']
    end
  end
end

Liquid::Template.register_filter(Jekyll::SystemFilter)
