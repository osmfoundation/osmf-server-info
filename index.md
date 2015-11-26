---
layout: default
---

There are {{ site.data.nodes.results }} machines managed by OSMF.

{% for node in site.data.nodes.rows %}
  * [{{ node.name }}]({{ site.baseurl }}/servers/{{ node.name }}/)
{% endfor %}
