---
layout: page
title: Motherboards
permalink: /motherboards/
---

This page lists the motherboard models in use across the OSMF servers,
and the servers that each model is fitted to.

{% assign motherboards = site.data.nodes.rows | motherboard_index %}

{% strip %}
Motherboard | Servers
------------|--------
{% for motherboard in motherboards %}
{{ motherboard.model | linkify: 'motherboards' }} | {% for server in motherboard.servers %}{% assign server_name = server | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server }}/){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
