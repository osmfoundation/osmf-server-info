---
layout: page
title: Power Supplies
permalink: /psus/
---

This page lists the power supply models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign psus = site.data.nodes.rows | psu_index %}

{% strip %}
Power Supply | Servers
-------------|--------
{% for psu in psus %}
{{ psu.model }} {{ psu.capacity }}W | {% for server in psu.servers %}{% assign server_name = server.name | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server.name }}/) ({{ server.count }}){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
