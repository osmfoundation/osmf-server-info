---
layout: page
title: Roles
permalink: /roles/
---

This page lists the Chef roles in use across the OSMF servers,
and the servers that carry each role.

{% assign roles = site.data.nodes.rows | role_index %}

{% strip %}
Role | Servers
-----|--------
{% for role in roles %}
{{ role.name }} | {% for server in role.servers %}{% assign server_name = server | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server }}/){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
