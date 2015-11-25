---
layout: default
---

There are {{ site.data.nodes.results }} machines managed by OSMF.

{% for node in site.data.nodes.rows %}
  * [{{ node.name }}](/servers/{{ node.name }}/)
{% endfor %}
