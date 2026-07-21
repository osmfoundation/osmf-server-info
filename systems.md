---
layout: page
title: Systems
permalink: /systems/
---

This page lists the system models in use across the OSMF servers,
and the servers of each model.

{% assign systems = site.data.nodes.rows | system_index %}

{% strip %}
System | Servers
-------|--------
{% for system in systems %}
{{ system.model | linkify: 'systems' }} | {% for server in system.servers %}{% assign server_name = server | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server }}/){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
