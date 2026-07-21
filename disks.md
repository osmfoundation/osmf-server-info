---
layout: page
title: Disks
permalink: /disks/
---

This page lists the disk models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign disks = site.data.nodes.rows | disk_index %}

{% strip %}
Disk | Servers
-----|--------
{% for disk in disks %}
{{ disk.model | linkify: 'disks' }} {{ disk.size }} | {% for server in disk.servers %}{% assign server_name = server.name | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server.name }}/) ({{ server.count }}){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
