---
layout: page
title: Network Controllers
permalink: /network-controllers/
---

This page lists the network controller models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign controllers = site.data.nodes.rows | network_controller_index %}

{% strip %}
Network Controller | Servers
-------------------|--------
{% for controller in controllers %}
{{ controller.model }} | {% for server in controller.servers %}{% assign server_name = server.name | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server.name }}/) ({{ server.count }}){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
