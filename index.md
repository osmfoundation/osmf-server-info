---
layout: default
---

{% assign sorted_nodes = site.data.nodes.rows | sort: 'name' %}

## [Equinix Amsterdam](#equinix-amsterdam)

{% strip %}
Server | Description | System | Stats | Last Contact
-------|-------------|--------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "equinix-ams" %}
{% assign node_name = node.name | split: '.' | first %}
{% assign node_system = node | system_name %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | {{ node_system }} | [prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## [Equinix Dublin](#equinix-dublin)

{% strip %}
Server | Description | System | Stats | Last Contact
-------|-------------|--------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "equinix-dub" %}
{% assign node_name = node.name | split: '.' | first %}
{% assign node_system = node | system_name %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | {{ node_system }} | [prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## [University College London](#university-college-london)

{% strip %}
Server | Description | System | Stats | Last Contact
-------|-------------|--------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "ucl" %}
{% assign node_name = node.name | split: '.' | first %}
{% assign node_system = node | system_name %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | {{ node_system }} | [prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## [Other](#other)

{% strip %}
Server | Description | Location | System | Stats | Last Contact
-------|-------------|----------|--------|-------|-------------
{% for node in sorted_nodes %}
{% unless node.automatic.roles contains "equinix-ams" or node.automatic.roles contains "equinix-dub" or node.automatic.roles contains "ucl" %}
{% assign node_name = node.name | split: '.' | first %}
{% assign node_system = node | system_name %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | Hosted by {{ node.default.hosted_by | linkify: 'isps' }} in {{ node.default.location }} | {{ node_system }} | [prometheus](https://prometheus.openstreetmap.org/d/Ea3IUVtMz/host-overview?orgId=1&var-instance={{ node_name }}) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endunless %}
{% endfor %}
{% endstrip %}
Last updated: {{ site.time | date_to_rfc822 }}
