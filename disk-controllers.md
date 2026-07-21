---
layout: page
title: Disk Controllers
permalink: /disk-controllers/
---

This page lists the disk controller models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign controllers = site.data.nodes.rows | disk_controller_index %}

{% strip %}
Disk Controller | Servers
----------------|--------
{% for controller in controllers %}
{{ controller.model | linkify: 'hbas' }} | {% for server in controller.servers %}{% assign server_name = server.name | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server.name }}/) ({{ server.count }}){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
