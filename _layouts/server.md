---
layout: default
---

# {{ page.title }}

{% assign node_name = page.title | split: '.' | first %}

{{ page.roles | server_description }} ([prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}))

<table class="server-table">
  <caption>Hardware</caption>
  <tbody>
    {% if page.server.system.name %}
    <tr><th scope="row">System</th><td>{{ page.server.system.name | linkify: 'systems' }}</td></tr>
    {% endif %}
    {% if page.server.system.motherboard %}
    <tr><th scope="row">Motherboard</th><td>{{ page.server.system.motherboard | linkify: 'motherboards' }}</td></tr>
    {% endif %}
    {% if page.server.cpus != empty %}
    <tr><th scope="row">CPU</th><td><ul>{% for cpu in page.server.cpus %}<li>{{ cpu.count }} x {{ cpu.cores }} core {{ cpu.model | linkify: 'cpus' }}</li>{% endfor %}</ul></td></tr>
    {% endif %}
    <tr><th scope="row">Memory</th><td><div>{{ page.server.memory.total }} Total</div>{% if page.server.memory.devices != empty %}<ul>{% for device in page.server.memory.devices %}<li>{{ device.count }} x {{ device.type }}</li>{% endfor %}</ul>{% endif %}</td></tr>
    {% if page.server.disk.controllers != empty %}
    <tr><th scope="row">Disk Controllers</th><td><ul>{% for controller in page.server.disk.controllers %}<li>{{ controller | linkify: 'hbas' }}</li>{% endfor %}</ul></td></tr>
    {% endif %}
    {% if page.server.disk.disks != empty %}
    <tr><th scope="row">Disks</th><td><ul>{% for disk in page.server.disk.disks %}<li>{{ disk.count }} x {{ disk.size }} {{ disk.type | linkify: 'disks' }}</li>{% endfor %}</ul></td></tr>
    {% endif %}
    {% if page.server.network.controllers != empty %}
    <tr><th scope="row">Network Controllers</th><td><ul>{% for controller in page.server.network.controllers %}<li>{{ controller }}</li>{% endfor %}</ul></td></tr>
    {% endif %}
    {% if page.server.power.psus != empty %}
    <tr><th scope="row">Power Supplies</th><td><ul>{% for psu in page.server.power.psus %}<li>{{ psu.count }} x {{ psu.capacity }}W {{ psu.type }}</li>{% endfor %}</ul></td></tr>
    {% endif %}
    {% if page.server.oob %}
    <tr><th scope="row">Out-of-band Management</th><td>{{ page.server.oob | linkify: 'oobs' }}</td></tr>
    {% endif %}
  </tbody>
</table>

<table class="server-table">
  <caption>Network</caption>
  <tbody>
  {% for interface in page.server.network.interfaces %}
    <tr>
      <th scope="row">{{ interface.name }}</th>
      <td><div>{{ interface.state }}</div>{% if interface.addresses != empty %}<ul>{% for address in interface.addresses %}<li>{{ address }}</li>{% endfor %}</ul>{% endif %}</td>
    </tr>
  {% endfor %}
  </tbody>
</table>

<table class="server-table">
  <caption>Software</caption>
  <tbody>
    {% if page.server.bios %}
    <tr><th scope="row">BIOS</th><td>{{ page.server.bios }}</td></tr>
    {% endif %}
    <tr><th scope="row">Operating System</th><td>{{ page.server.os }}</td></tr>
  </tbody>
</table>

<table class="server-table">
  <caption>Roles</caption>
  <tbody>
  {% for role in page.server.roles %}
    <tr><th scope="row">{{ role.name }}</th><td>{{ role.description }}</td></tr>
  {% endfor %}
  </tbody>
</table>

{% if page.server.disk.arrays != empty %}
<table class="server-table">
  <caption>Disk Arrays</caption>
  <tbody>
  {% for array in page.server.disk.arrays %}
    <tr><th scope="row">{{ array.device }}</th><td>{{ array.size }} RAID{{ array.level }} array over {{ array.disks }} disks</td></tr>
  {% endfor %}
  </tbody>
</table>
{% endif %}

{% if page.server.lvs != empty %}
<table class="server-table">
  <caption>Logical Volumes</caption>
  <tbody>
  {% for lv in page.server.lvs %}
    <tr><th scope="row">{{ lv.name }}</th><td>{{ lv.description }}</td></tr>
  {% endfor %}
  </tbody>
</table>
{% endif %}

{% if page.server.filesystems != empty %}
<table class="server-table">
  <caption>Filesystems</caption>
  <tbody>
  {% for fs in page.server.filesystems %}
    <tr><th scope="row" class="wide-col">{{ fs.mountpoint }}</th><td class="path-col">{{ fs.description }}</td></tr>
  {% endfor %}
  </tbody>
</table>
{% endif %}

## Thanks

Many thanks to {{ page.thanks_to | linkify: 'isps' }} for supporting this server. {{ page.additional_thanks }}

Last updated: {{ site.time | date_to_rfc822 }}
