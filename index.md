---
layout: default
---

{% assign sorted_nodes = site.data.nodes.rows | sort: 'name' %}

## Imperial College London

{% strip %}
Server | Description | Stats | Last Contact
-------|-------------|-------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "ic" %}
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


## Tile Caches

{% strip %}
Server | Description | Country |Stats | Last Contact
-------|-------------|:-------:|------|-------------
{% for node in sorted_nodes %}
{% if node.automatic.roles contains "tilecache" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | Tile cache server in {{ node.automatic.location }} | <span class="flag-icon flag-icon-{{ node.override.country }}"></span> | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endif %}
{% endfor %}
{% endstrip %}


## Other

{% strip %}
Server | Description | Stats | Last Contact
-------|-------------|-------|-------------
{% for node in sorted_nodes %}
{% unless node.automatic.roles contains "ic" or node.automatic.roles contains "ucl" or node.automatic.roles contains "tilecache" %}
{% assign node_name = node.name | split: '.' | first %}
[{{ node_name }}]({{ site.baseurl }}/servers/{{ node.name }}/) | {{ node.automatic.roles | server_description }} | [munin](http://munin.openstreetmap.org/openstreetmap/{{ node_name }}.openstreetmap/index.html) | {{ node.automatic.ohai_time | date_to_pretty }}
{% endunless %}
{% endfor %}
{% endstrip %}
