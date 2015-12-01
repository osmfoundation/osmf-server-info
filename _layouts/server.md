---
layout: default
---

# {{ page.title }}

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

**Out-of-band Management**
: N/A

## Network

{% for interface in page.server.network.interfaces %}
**{{ interface.name }}**
: {% for address in interface.addresses %}* {{ address }}
  {% endfor %}

{% endfor %}

## Software

{% if page.server.bios %}
**BIOS**
: {{ page.server.bios }}
{% endif %}

**Operating System**
: {{ page.server.os }}

{% if page.server.disk.arrays != empty %}
## Disk Arrays
{% for array in page.server.disk.arrays %}
**{{ array.device }}**
: {{ array.size }} RAID{{ array.level }} array over {{ array.disks }} disks

{% endfor %}
{% endif %}

## Disk Partitions

Mount Point | Device | Notes
