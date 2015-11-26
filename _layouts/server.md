---
layout: default
---

# {{ page.server.name }}

## Hardware

**Chassis** | {{ page.server.automatic.dmi.system.manufacturer }} {{ page.server.automatic.dmi.system.product_name }}
**CPU** | {{ page.server.automatic.cpu.real }}x {{ page.server.automatic.cpu.total |divided_by: page.server.automatic.cpu.real }}-core {{ page.server.automatic.cpu.0.model_name }}
**Memory** | {{ page.server.automatic.memory.total }}
**Motherboard** |
**Raid Controller** |
**Disk** |
**Out-of-band Management** |

## Network
<table>
  <thead>
    <th>interface</th>
    <th>mac</th>
    <th>IPs</th>
  </thead>
  <tbody>
  {% for interface in page.server.automatic.network.interfaces %}
    {% if interface[0] != 'lo' %}
      {% assign addresses = '' %}
      {% for address in interface[1].addresses %}
        {% if address[1].family == 'lladdr' %}
          {% assign mac = address[0] %}
        {% else %}
          {% if address[1].scope != 'Link' %}
            {% capture addresses %}{{ addresses }}, {{ address[0] }}{% endcapture %}
          {% endif %}
        {% endif %}
      {% endfor %}
      <tr><td>{{ interface[0] }}</td><td>{{ mac }}</td><td>{{ addresses | remove_first: ',' }}</td></tr>
    {% endif %}
  {% endfor %}
  </tbody>
</table>

## Software

**Operating System** | {{ page.server.automatic.lsb.description }}

## Disk Partitions

Mount Point | Device | Notes
