---
layout: page
title: CPUs
permalink: /cpus/
---

This page lists the CPU models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign cpus = site.data.nodes.rows | cpu_index %}

{% strip %}
CPU | Servers
----|--------
{% for cpu in cpus %}
{{ cpu.model | linkify: 'cpus' }} ({{ cpu.cores }} core) | {% for server in cpu.servers %}{% assign server_name = server.name | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server.name }}/) ({{ server.count }}){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
