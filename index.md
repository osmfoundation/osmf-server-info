---
layout: default
---

There are {{ site.data.nodes.results }} machines managed by OSMF.

{% assign sorted_nodes = site.data.nodes.rows | sort: 'name' %}

{% for node in sorted_nodes %}
  * [{{ node.name }}]({{ site.baseurl }}/servers/{{ node.name }}/)
{% endfor %}
