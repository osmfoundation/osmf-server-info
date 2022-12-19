---
layout: default
---

# {{ page.title }}

{% assign node_name = page.title | split: '.' | first %}

{{ page.roles | server_description }} ([prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}))

## Hardware

{% if page.server.system.name %}
**System**
: {{ page.server.system.name | linkify: 'systems' }}
{% endif %}

{% if page.server.system.motherboard %}
**Motherboard**
: {{ page.server.system.motherboard | linkify: 'motherboards' }}
{% endif %}

{% if page.server.cpus != empty %}
**CPU**
: {% for cpu in page.server.cpus %}* {{ cpu.count }} x {{ cpu.cores }} core {{ cpu.model | linkify: 'cpus' }}
  {% endfor %}
{% endif %}

**Memory**
: * {{ page.server.memory.total }} Total
  {% for device in page.server.memory.devices %}* {{ device.count }} x {{ device.type }}
  {% endfor %}

{% if page.server.disk.controllers != empty %}
**Disk Controllers**
: {% for controller in page.server.disk.controllers %}* {{ controller | linkify: 'hbas' }}
  {% endfor %}
{% endif %}

{% if page.server.disk.disks != empty %}
**Disks**
: {% for disk in page.server.disk.disks %}* {{ disk.count }} x {{ disk.size }} {{ disk.type | linkify: 'disks' }}
  {% endfor %}
{% endif %}

{% if page.server.network.controllers != empty %}
**Network Controllers**
: {% for controller in page.server.network.controllers %}* {{ controller }}
  {% endfor %}
{% endif %}

{% if page.server.power.psus != empty %}
**Power Supplies**
: {% for psu in page.server.power.psus %}* {{ psu.count }} x {{ psu.capacity }}W {{ psu.type }}
  {% endfor %}
{% endif %}

{% if page.server.oob %}
**Out-of-band Management**
: {{ page.server.oob | linkify: 'oobs' }}
{% endif %}

## Network

{% for interface in page.server.network.interfaces %}
**{{ interface.name }}**
: {{ interface.state }}
  {% for address in interface.addresses %}* {{ address }}
  {% endfor %}

{% endfor %}

## Software

{% if page.server.bios %}
**BIOS**
: {{ page.server.bios }}
{% endif %}

**Operating System**
: {{ page.server.os }}

## Roles

{% for role in page.server.roles %}
**{{ role.name }}**
: {{ role.description }}

{% endfor %}

{% if page.server.disk.arrays != empty %}
## Disk Arrays
{% for array in page.server.disk.arrays %}
**{{ array.device }}**
: {{ array.size }} RAID{{ array.level }} array over {{ array.disks }} disks

{% endfor %}
{% endif %}

{% if page.server.lvs != empty %}
## Logical Volumes

{% for lv in page.server.lvs %}
**{{ lv.name }}**
: {{ lv.description }}

{% endfor %}
{% endif %}

{% if page.server.filesystems != empty %}
## Filesystems

{% for fs in page.server.filesystems %}
**{{ fs.mountpoint }}**
: {{ fs.description }}

{% endfor %}
{% endif %}

## Thanks

Many thanks to {{ page.thanks_to | linkify: 'isps' }} for supporting this server. {{ page.additional_thanks }}

Last updated: {{ site.time | date_to_rfc822 }}
