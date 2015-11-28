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

**Raid Controller**
: N/A

**Disk**
: N/A

**Out-of-band Management**
: N/A

## Network

{% for interface in page.server.interfaces %}
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

## Disk Partitions

Mount Point | Device | Notes
