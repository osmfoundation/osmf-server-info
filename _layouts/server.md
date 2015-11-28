---
layout: default
---

# {{ page.title }}

## Hardware

**Chassis**
: {{ page.server.chassis }}

**CPU**
: {% for cpu in page.server.cpus %}* {{ cpu.count }} x {{ cpu.cores }} core {{ cpu.model | linkify: 'cpus' }}
  {% endfor %}

**Memory**
: {{ page.server.memory }}

**Motherboard**
: N/A

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

**Operating System**
: {{ page.server.os }}

## Disk Partitions

Mount Point | Device | Notes
