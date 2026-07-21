---
layout: page
title: Out-of-band Management
permalink: /oobs/
---

This page lists the out-of-band management controllers in use across the
OSMF servers, and the servers that each one is fitted to.

{% assign oobs = site.data.nodes.rows | oob_index %}

{% strip %}
Out-of-band Management | Servers
-----------------------|--------
{% for oob in oobs %}
{{ oob.model | linkify: 'oobs' }} | {% for server in oob.servers %}{% assign server_name = server | split: '.' | first %}[{{ server_name }}]({{ site.baseurl }}/servers/{{ server }}/){% unless forloop.last %}, {% endunless %}{% endfor %}
{% endfor %}
{% endstrip %}

Last updated: {{ site.time | date_to_rfc822 }}
