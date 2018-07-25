---
layout: default
---

{% assign sorted_nodes = site.data.nodes.rows | sort: 'name' %}

## Equinix Amsterdam

{% strip %}
Server | Description | Stats | Last Contact
-------|-------------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "equinix" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## University College London

{% strip %}
Server | Description | Stats | Last Contact
-------|-------------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "ucl" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## Bytemark

{% strip %}
Server | Description | Stats | Last Contact
-------|-------------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "bytemark" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}

## Tile Caches

{% strip %}
Server | Location | Country |Stats | Last Contact
-------|----------|:-------:|------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "tilecache" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | Hosted by {{ node.default.hosted_by | linkify: 'isps' }} in {{ node.default.location }} | <span class="flag-icon flag-icon-{{ node.override.country }}"></span> | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}


## Other

{% strip %}
Server | Description | Location | Stats | Last Contact
-------|-------------|----------|-------|-------------
{% for node in sorted_nodes %}
{% unless node.automatic.roles contains "ic" or node.automatic.roles contains "ucl" or node.automatic.roles contains "bytemark" or node.automatic.roles contains "tilecache" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | Hosted by {{ node.default.hosted_by | linkify: 'isps' }} in {{ node.default.location }} | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endunless %}
{% endfor %}
{% endstrip %}
